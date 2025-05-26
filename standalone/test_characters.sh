#!/bin/bash

# Configuración
DATASET_FILE="book.txt"
INPUT_DIR=~/input
HADOOP_JAR=$(ls ~/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar)
OUTPUT_BASE=~/output_characters
CSV_OUT=~/characters.csv

# Paso 1: Verificar archivo fuente
mkdir -p "$INPUT_DIR"
cd "$INPUT_DIR"

if [ ! -f "$DATASET_FILE" ]; then
    echo "⚠️ Archivo $DATASET_FILE no encontrado."
    exit 1
fi

# Paso 2: Limpiar y normalizar texto
sed 's/[^a-zA-Z]/ /g' "$DATASET_FILE" > "$INPUT_DIR/input_alpha.txt"

# Paso 3: Filtrar menciones de characters clave
echo "📌 Extrayendo nombres de characters..."

CHARACTERS="Ishmael|Ahab|Queequeg|Starbuck|Stubb|Flask|Fedallah"
grep -Eow "$CHARACTERS" "$INPUT_DIR/input_alpha.txt" > "$INPUT_DIR/input_characters.txt"

# Paso 4: Ejecutar WordCount
echo "⚙️ Ejecutando WordCount para characters..."
rm -rf "$OUTPUT_BASE"
hadoop jar "$HADOOP_JAR" wordcount "$INPUT_DIR/input_characters.txt" "$OUTPUT_BASE"

# Paso 5: Convertir a CSV
cat "$OUTPUT_BASE/part-r-00000" | awk '{ print $1 "," $2 }' > "$CSV_OUT"

# Paso 6: Mostrar top characters
echo "📊 Conteo de menciones por character:"
cat "$CSV_OUT" | sort -t',' -k2 -nr

echo "✅ Resultados guardados en: $CSV_OUT"
