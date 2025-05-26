#!/bin/bash

INPUT_DIR=~/input
mkdir -p "$INPUT_DIR"

TMP_DIR=$(mktemp -d)
PAGE=1

while true; do
    START_INDEX=$(( (PAGE - 1) * 25 + 1 ))
    PAGE_URL="https://www.gutenberg.org/ebooks/search/?sort_order=downloads&start_index=$START_INDEX"

    echo "🔄 Cargando página $PAGE de libros populares..."
    curl -s "$PAGE_URL" > "$TMP_DIR/page.html"

    # Extraer IDs y títulos (alineados por líneas)
    grep -oP '/ebooks/\d+' "$TMP_DIR/page.html" | cut -d'/' -f3 | sort -u > "$TMP_DIR/ids.txt"
    grep -oP '(?<=class="title">)[^<]+' "$TMP_DIR/page.html" > "$TMP_DIR/titles.txt"

    paste "$TMP_DIR/titles.txt" "$TMP_DIR/ids.txt" > "$TMP_DIR/entries.txt"

    # Agregar opciones de navegación
    echo -e "➡️ Siguiente página\tnext" >> "$TMP_DIR/entries.txt"
    echo -e "❌ Salir\tquit" >> "$TMP_DIR/entries.txt"

    echo "📚 Página $PAGE: elige un libro o acción"
    SELECTION=$(column -t -s $'\t' "$TMP_DIR/entries.txt" | fzf --ansi --height=20 --prompt="Libro > ")

    # Obtener el ID del libro o comando
    SELECTED_ID=$(echo "$SELECTION" | awk '{print $NF}')
    BOOK_TITLE=$(echo "$SELECTION" | sed -E 's/\s+[0-9]+$//' | sed -E 's/\s+\t.*$//')

    if [[ "$SELECTED_ID" == "next" ]]; then
        PAGE=$((PAGE + 1))
        continue
    elif [[ "$SELECTED_ID" == "quit" ]] || [ -z "$SELECTED_ID" ]; then
        echo "👋 Saliendo."
        break
    else
        DATASET_FILE="pg$SELECTED_ID.txt"
        DATASET_URL="https://www.gutenberg.org/cache/epub/$SELECTED_ID/pg$SELECTED_ID.txt"

        echo "📥 Descargando '$BOOK_TITLE'..."
        wget -q "$DATASET_URL" -O "$DATASET_FILE"
        if [ $? -ne 0 ]; then
            echo "❌ Error al descargar el libro. Probablemente no tiene versión .txt disponible."
            rm -f "$DATASET_FILE"
            continue
        fi

        cp "$DATASET_FILE" "$INPUT_DIR/book.txt"
        echo "✅ Libro guardado como $INPUT_DIR/book.txt"
        break
    fi
done

rm -rf "$TMP_DIR"
