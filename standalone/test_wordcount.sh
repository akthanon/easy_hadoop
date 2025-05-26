#!/bin/bash

# Configuración
DATASET_FILE="book.txt"
INPUT_DIR=~/input
HADOOP_JAR=$(ls ~/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar)
OUTPUT_BASE=~/output_test
CSV_OUT=~/wordcount_mobydick.csv

# Paso 1: Descargar libro
mkdir -p "$INPUT_DIR"

# Paso 2: Copiar el archivo completo (sin dividir) al HDFS local
echo "📂 Preparando archivo para Hadoop..."
rm -f "$INPUT_DIR"/input.txt
cp "$DATASET_FILE" "$INPUT_DIR/input.txt"

# Limpiar signos de puntuación y convertir a minúsculas
sed 's/[^a-zA-Z]/ /g' "$INPUT_DIR/input.txt" | tr '[:upper:]' '[:lower:]' > "$INPUT_DIR/input_clean.txt"

# Paso 3: Ejecutar WordCount
echo "⚙️ Ejecutando WordCount..."
rm -rf "$OUTPUT_BASE/wordcount"
hadoop jar "$HADOOP_JAR" wordcount "$INPUT_DIR/input_clean.txt" "$OUTPUT_BASE/wordcount"

# Paso 4: Convertir salida a CSV y ordenar
echo "📄 Formateando resultados a CSV..."
cat "$OUTPUT_BASE/wordcount"/part-r-* | \
    awk '{ print $1 "," $2 }' > "$CSV_OUT"

echo "📊 Top 10 palabras más frecuentes:"
sort -t',' -k2 -nr "$CSV_OUT" | head -n 10

# Paso 5: Ejecutar Grep
echo "🔍 Ejecutando Grep (palabras que contienen 'whal')..."
rm -rf "$OUTPUT_BASE/grep"
hadoop jar "$HADOOP_JAR" grep "$INPUT_DIR/input.txt" "$OUTPUT_BASE/grep" "whal[a-zA-Z]*"

echo "✅ Resultados Grep:"
head -n 10 "$OUTPUT_BASE/grep/part-r-00000"

# Paso 6: Saltar InvertedIndex (no está disponible en Hadoop por defecto)
echo "🚫 InvertedIndex no está disponible por defecto en hadoop-mapreduce-examples."

# Paso 7: Limpieza (opcional)
echo "🧹 Limpiando temporales..."
rm -f "$INPUT_DIR"/part_* "$INPUT_DIR"/input.txt

echo "✅ Script finalizado. Resultados en: $CSV_OUT"