#!/bin/bash
# Cheat Sheet Genérico para Análisis con Hadoop
# 5 tipos de análisis: wordcount, bigramas/trigramas, personajes, sentimientos, temas
# Usar con archivos de texto limpios (sin puntuación, minúsculas)

# Configuración general (modifica según tu entorno)
HADOOP_JAR=$(ls ~/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar)
INPUT_LOCAL_DIR=~/input_text       # Carpeta local con textos limpios
INPUT_HDFS_DIR=/user/$(whoami)/input_text
OUTPUT_HDFS_DIR=/user/$(whoami)/output_analysis

echo "➡️  Subiendo archivos limpios a HDFS..."
hdfs dfs -mkdir -p $INPUT_HDFS_DIR
hdfs dfs -put -f $INPUT_LOCAL_DIR/* $INPUT_HDFS_DIR/

echo "➡️  Limpiando resultados previos..."
hdfs dfs -rm -r -f $OUTPUT_HDFS_DIR/*

# 1. Conteo de palabras (WordCount)
echo "🔢 Ejecutando WordCount (conteo palabras)..."
hadoop jar $HADOOP_JAR wordcount $INPUT_HDFS_DIR $OUTPUT_HDFS_DIR/wordcount

# 2. N-gramas (Bigramas y Trigramas)
# Requiere jobs MapReduce personalizados, aquí ejemplo con jar ficticio 'ngram-count.jar'
echo "🔤 Ejecutando conteo de bigramas..."
hadoop jar ~/custom_jars/ngram-count.jar -input $INPUT_HDFS_DIR -output $OUTPUT_HDFS_DIR/bigrams -ngram 2

echo "🔤 Ejecutando conteo de trigramas..."
hadoop jar ~/custom_jars/ngram-count.jar -input $INPUT_HDFS_DIR -output $OUTPUT_HDFS_DIR/trigrams -ngram 3

# 3. Análisis de personajes (grep de palabras clave)
# Define palabras clave separadas por '|' para grep
PERSONAJES="queequeg|ahab|ishmael|starbuck|stubb"
echo "🎭 Buscando personajes con grep..."
hadoop jar $HADOOP_JAR grep $INPUT_HDFS_DIR $OUTPUT_HDFS_DIR/personajes "$PERSONAJES"

# 4. Detección de sentimientos por capítulos
# Supone que el texto ya está dividido en capítulos en INPUT_LOCAL_DIR
echo "🧠 Conteo palabras por capítulo (para análisis de sentimiento)..."
hadoop jar $HADOOP_JAR wordcount $INPUT_HDFS_DIR $OUTPUT_HDFS_DIR/wordcount_capitulos

# 5. Evolución de temas (LDA / tópicos)
# Ejemplo de ejecución con jar personalizado para modelado de temas
echo "📚 Ejecutando modelado de temas (LDA) por capítulo..."
hadoop jar ~/custom_jars/lda-topic-model.jar -input $INPUT_HDFS_DIR -output $OUTPUT_HDFS_DIR/temas

# Fin
echo "✅ Análisis completados. Resultados en HDFS bajo: $OUTPUT_HDFS_DIR"
echo "Puedes ver resultados con:"
echo "  hdfs dfs -cat $OUTPUT_HDFS_DIR/wordcount/part-r-*"
echo "  hdfs dfs -cat $OUTPUT_HDFS_DIR/bigrams/part-r-*"
echo "  hdfs dfs -cat $OUTPUT_HDFS_DIR/trigrams/part-r-*"
echo "  hdfs dfs -cat $OUTPUT_HDFS_DIR/personajes/part-r-*"
echo "  hdfs dfs -cat $OUTPUT_HDFS_DIR/wordcount_capitulos/part-r-*"
echo "  hdfs dfs -cat $OUTPUT_HDFS_DIR/temas/part-r-*"
