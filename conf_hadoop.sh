#!/bin/bash

# Ruta de instalación de Hadoop (ajústala si está en otro lugar)
HADOOP_DIR=~/hadoop

# Detectar ruta JAVA_HOME
JAVA_HOME_DETECT=$(readlink -f $(which java) | sed "s:bin/java::")

echo "JAVA detectado en: $JAVA_HOME_DETECT"
echo "Configurando variables de entorno..."

# Añadir a ~/.bashrc si no están
if ! grep -q "HADOOP_HOME" ~/.bashrc; then
cat <<EOF >> ~/.bashrc

# >>> Configuración de Hadoop <<<
export HADOOP_HOME=$HADOOP_DIR
export HADOOP_INSTALL=\$HADOOP_HOME
export HADOOP_MAPRED_HOME=\$HADOOP_HOME
export HADOOP_COMMON_HOME=\$HADOOP_HOME
export HADOOP_HDFS_HOME=\$HADOOP_HOME
export YARN_HOME=\$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=\$HADOOP_HOME/lib/native
export PATH=\$PATH:\$HADOOP_HOME/sbin:\$HADOOP_HOME/bin
export JAVA_HOME=$JAVA_HOME_DETECT
# <<< Fin configuración de Hadoop <<<
EOF
    echo "Variables añadidas a ~/.bashrc"
else
    echo "Las variables ya estaban configuradas en ~/.bashrc"
fi

# Configurar hadoop-env.sh
ENV_SH="$HADOOP_DIR/etc/hadoop/hadoop-env.sh"
if grep -q "^export JAVA_HOME=" "$ENV_SH"; then
    sed -i "s|^export JAVA_HOME=.*|export JAVA_HOME=$JAVA_HOME_DETECT|" "$ENV_SH"
else
    echo "export JAVA_HOME=$JAVA_HOME_DETECT" >> "$ENV_SH"
fi

echo "Archivo hadoop-env.sh configurado."

# Aplicar cambios
source ~/.bashrc
echo "✅ Variables de entorno configuradas correctamente."