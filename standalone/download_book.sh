#!/bin/bash
BOOK_INDEX="2701"
DATASET_FILE="pg$BOOK_INDEX.txt"
DATASET_URL="https://www.gutenberg.org/cache/epub/$BOOK_INDEX/pg$BOOK_INDEX.txt"
if [ ! -f "$DATASET_FILE" ]; then
    echo "📥 Descargando 'Moby Dick'..."
    wget "$DATASET_URL"
else
    echo "✅ Libro ya descargado."
fi

mkdir -p "$INPUT_DIR"
cd "$INPUT_DIR"

cp $DATASET_FILE $INPUT_DIR/book.txt