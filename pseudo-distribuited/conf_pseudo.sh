#!/bin/bash

# Requiere que HADOOP_HOME esté definido
if [ -z "$HADOOP_HOME" ]; then
    echo "Error: HADOOP_HOME no está definido"
    exit 1
fi

mkdir -p "$HADOOP_HOME/etc/hadoop"

add_config_block() {
    local file="$1"
    local check_string="$2"
    local content="$3"

    if [ ! -f "$file" ]; then
        echo "<configuration>" > "$file"
        echo "</configuration>" >> "$file"
    fi

    if ! grep -q "$check_string" "$file"; then
        tmpfile=$(mktemp)
        echo "$content" > "$tmpfile"
        sed -i "/<\/configuration>/e cat $tmpfile" "$file"
        rm "$tmpfile"
        echo "Configuración agregada a $(basename "$file")"
    else
        echo "La configuración ya existe en $(basename "$file")"
    fi
}

# ------- core-site.xml -------
core_content=$(cat << EOF
  <property>
    <name>hadoop.tmp.dir</name>
    <value>/home/hdoop/tmpdata</value>
  </property>

  <property>
    <name>fs.default.name</name>
    <value>hdfs://127.0.0.1:9000</value>
  </property>
EOF
)

add_config_block "$HADOOP_HOME/etc/hadoop/core-site.xml" "fs.default.name" "$core_content"

# ------- hdfs-site.xml -------
hdfs_content=$(cat << EOF
  <property>
    <name>dfs.name.dir</name>
    <value>/home/hdoop/dfsdata/namenode</value>
  </property>

  <property>
    <name>dfs.data.dir</name>
    <value>/home/hdoop/dfsdata/datanode</value>
  </property>

  <property>
    <name>dfs.replication</name>
    <value>1</value>
  </property>
EOF
)

add_config_block "$HADOOP_HOME/etc/hadoop/hdfs-site.xml" "dfs.name.dir" "$hdfs_content"

# ------- mapred-site.xml -------
mapred_file="$HADOOP_HOME/etc/hadoop/mapred-site.xml"
mapred_content=$(cat << EOF
  <property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
  </property>
EOF
)

add_config_block "$mapred_file" "mapreduce.framework.name" "$mapred_content"

# ------- yarn-site.xml -------
yarn_content=$(cat << EOF
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>

  <property>
    <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
    <value>org.apache.hadoop.mapred.ShuffleHandler</value>
  </property>

  <property>
    <name>yarn.resourcemanager.hostname</name>
    <value>127.0.0.1</value>
  </property>

  <property>
    <name>yarn.acl.enable</name>
    <value>0</value>
  </property>

  <property>
    <name>yarn.nodemanager.env-whitelist</name>
    <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PERPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>
  </property>
EOF
)

add_config_block "$HADOOP_HOME/etc/hadoop/yarn-site.xml" "yarn.resourcemanager.hostname" "$yarn_content"
