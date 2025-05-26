#!/bin/bash

# Configuración
DATASET_FILE="pg2701.txt"
INPUT_DIR=~/input
CHAPTERS_DIR="$INPUT_DIR/chapters"
CSV_OUT=~/sentimientos_mobydick.csv

# Paso 1: Verificar archivo original
mkdir -p "$INPUT_DIR"
cd "$INPUT_DIR"

if [ ! -f "$DATASET_FILE" ]; then
    echo "⚠️ Archivo $DATASET_FILE no encontrado."
    exit 1
fi

# Paso 2: Dividir el texto por capítulos
echo "📖 Dividiendo capítulos..."
rm -rf "$CHAPTERS_DIR"
mkdir -p "$CHAPTERS_DIR"

awk '
BEGIN { chapter=0 }
/^CHAPTER [0-9IVXLCDM]+/ {
    chapter++;
    file=sprintf("'"$CHAPTERS_DIR"'/chapter_%03d.txt", chapter);
}
{ print >> file }
' "$DATASET_FILE"

echo "📝 Se crearon $(ls $CHAPTERS_DIR | wc -l) capítulos."

# Paso 3: Generar CSV con análisis de sentimiento
echo "🧠 Analizando sentimiento por capítulo..."
python3 <<EOF
from textblob import TextBlob
import os
import csv

chapters_dir = os.path.expanduser("$CHAPTERS_DIR")
output_csv = os.path.expanduser("$CSV_OUT")

data = []
for fname in sorted(os.listdir(chapters_dir)):
    with open(os.path.join(chapters_dir, fname)) as f:
        text = f.read()
        blob = TextBlob(text)
        polarity = blob.sentiment.polarity
        data.append((fname, polarity))

with open(output_csv, "w") as f:
    writer = csv.writer(f)
    writer.writerow(["chapter", "polarity"])
    writer.writerows(data)
EOF

echo "✅ Sentimientos guardados en: $CSV_OUT"
