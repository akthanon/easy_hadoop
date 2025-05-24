#!/bin/bash

# Verificar si python3-pip está instalado
if ! dpkg -s python3-pip &>/dev/null; then
    echo "Instalando python3-pip..."
    sudo apt update
    sudo apt install python3-pip -y
else
    echo "python3-pip ya está instalado."
fi

# Verificar si python3-venv está instalado
if ! dpkg -s python3-venv &>/dev/null; then
    echo "Instalando python3-venv..."
    sudo apt update
    sudo apt install python3-venv -y
else
    echo "python3-venv ya está instalado."
fi

# Crear entorno virtual si no existe
if [ ! -d "$HOME/venv_hadoop" ]; then
    echo "Creando entorno virtual..."
    python3 -m venv "$HOME/venv_hadoop"
else
    echo "El entorno virtual ya existe."
fi

# Activar entorno virtual
source "$HOME/venv_hadoop/bin/activate"

# Verificar si matplotlib está instalado en el entorno virtual
if ! pip show matplotlib &>/dev/null; then
    echo "Instalando matplotlib..."
    pip install matplotlib
else
    echo "matplotlib ya está instalado."
fi

# Verificar si pandas está instalado en el entorno virtual
if ! pip show pandas &>/dev/null; then
    echo "Instalando pandas..."
    pip install pandas
else
    echo "pandas ya está instalado."
fi

# Ejecutar el script de Python
if [ -f "$HOME/easy_hadoop/standalone/graph_wordcount.py" ]; then
    echo "Ejecutando graph_wordcount.py..."
    python "$HOME/easy_hadoop/standalone/graph_wordcount.py"
elif [ -f "$HOME/graf_wordcount.py" ]; then
    echo "Ejecutando graf_wordcount.py..."
    python "$HOME/graf_wordcount.py"
else
    echo "No se encontró el script de Python para ejecutar."
fi

# Desactivar entorno virtual
deactivate

echo "Proceso completado. Verifica ~/top_palabras_mobydick.png"
