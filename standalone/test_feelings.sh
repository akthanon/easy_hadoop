#!/bin/bash

# Configuración
DATASET_FILE="pg2701.txt"
INPUT_DIR=~/input
CHAPTERS_DIR="$INPUT_DIR/chapters"
CSV_OUT=~/sentimientos_mobydick.csv
VENV_DIR="$HOME/venv_hadoop"

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
/^CHAPTER [0-9IVXLCDM]+/ || /^Chapter [0-9IVXLCDM]+/ {
    chapter++;
    file=sprintf("'"$CHAPTERS_DIR"'/chapter_%03d.txt", chapter);
}
{ if (file != "") print >> file }
' "$DATASET_FILE"

CHAPTER_COUNT=$(ls "$CHAPTERS_DIR" | wc -l)
echo "📝 Se crearon $CHAPTER_COUNT capítulos."

# Paso 3: Activar entorno virtual
if [ ! -d "$VENV_DIR" ]; then
    echo "❌ Entorno virtual $VENV_DIR no encontrado. Ejecuta primero run_sentimientos.sh"
    exit 1
fi

source "$VENV_DIR/bin/activate"
pip install matplotlib pandas textblob --quiet
python3 -m textblob.download_corpora

# Paso 4: Generar CSV con análisis de sentimiento
echo "🧠 Analizando sentimiento por capítulo..."
python3 <<EOF
from textblob import TextBlob
import os
import csv

chapters_dir = os.path.expanduser("$CHAPTERS_DIR")
output_csv = os.path.expanduser("$CSV_OUT")

data = []
for fname in sorted(os.listdir(chapters_dir)):
    with open(os.path.join(chapters_dir, fname), encoding='utf-8') as f:
        text = f.read()
        blob = TextBlob(text)
        polarity = blob.sentiment.polarity
        data.append((fname, polarity))

with open(output_csv, "w", newline='') as f:
    writer = csv.writer(f)
    writer.writerow(["chapter", "polarity"])
    writer.writerows(data)
EOF

# Paso 5: Desactivar entorno virtual
deactivate

echo "✅ Sentimientos guardados en: $CSV_OUT"
