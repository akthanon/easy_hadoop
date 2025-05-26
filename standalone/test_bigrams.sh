#!/bin/bash

# Configuración
DATASET_FILE="book.txt"
INPUT_DIR=~/input
HADOOP_JAR=$(ls ~/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar)
OUTPUT_BASE=~/output_bigrams
CSV_OUT=~/bigrams.csv

# Paso 1: Preparar archivo de entrada
mkdir -p "$INPUT_DIR"
cd "$INPUT_DIR"

if [ ! -f "$DATASET_FILE" ]; then
    echo "⚠️ Archivo $DATASET_FILE no encontrado."
    exit 1
fi

# Limpiar signos de puntuación y convertir a minúsculas
sed 's/[^a-zA-Z]/ /g' "$DATASET_FILE" | tr '[:upper:]' '[:lower:]' > "$INPUT_DIR/input_clean.txt"

# Paso 2: Crear archivo de bigramas temporal
echo "🧠 Generando bigramas..."
python3 <<EOF
with open("$INPUT_DIR/input_clean.txt") as f:
    words = f.read().split()
    bigrams = zip(words, words[1:])
    with open("$INPUT_DIR/input_bigrams.txt", "w") as out:
        for b in bigrams:
            out.write(f"{b[0]}_{b[1]}\n")
EOF

# Paso 3: Ejecutar WordCount en los bigramas
echo "⚙️ Ejecutando WordCount para bigramas..."
rm -rf "$OUTPUT_BASE"
hadoop jar "$HADOOP_JAR" wordcount "$INPUT_DIR/input_bigrams.txt" "$OUTPUT_BASE"

# Paso 4: Convertir a CSV
echo "📄 Generando CSV de bigramas..."
cat "$OUTPUT_BASE/part-r-00000" | awk '{ print $1 "," $2 }' > "$CSV_OUT"

# Paso 5: Mostrar top 10
echo "📊 Top 10 bigramas más frecuentes:"
sort -t',' -k2 -nr "$CSV_OUT" | head -n 10

echo "✅ Resultados en: $CSV_OUT"
