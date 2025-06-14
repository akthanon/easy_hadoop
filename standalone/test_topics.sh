#!/bin/bash

# Configuración
CHAPTERS_DIR=~/input/chapters
CSV_OUT=~/topics.csv
VENV_DIR="$HOME/venv_hadoop"

# Paso 1: Verificar capítulos
if [ ! -d "$CHAPTERS_DIR" ]; then
    echo "❌ Directorio de capítulos no encontrado. Ejecuta primero el análisis de sentimientos."
    exit 1
fi

# Verificar si python3-venv está instalado
if ! dpkg -s python3-venv &>/dev/null; then
    echo "Instalando python3-venv..."
    sudo apt update
    sudo apt install python3-venv -y
fi

# Crear entorno virtual si no existe
if [ ! -d "$HOME/venv_hadoop" ]; then
    echo "Creando entorno virtual..."
    python3 -m venv "$HOME/venv_hadoop"
fi

# Paso 3: Activar entorno virtual
source "$VENV_DIR/bin/activate"

# Instalar dependencias necesarias
pip install pandas matplotlib nltk gensim --quiet

# Descargar recursos de NLTK
python3 -c "
import nltk
nltk.download('punkt')
nltk.download('stopwords')
"
# Paso 4: Verificar gensim
if ! python3 -c "import gensim" &>/dev/null; then
    echo "📦 Instalando gensim en el entorno virtual..."
    pip install gensim --quiet
fi

deactivate
source "$VENV_DIR/bin/activate"
# Paso 5: Ejecutar análisis de temas
echo "📚 Analizando temas por capítulo con LDA..."
python3 <<EOF
import os
import pandas as pd
from gensim import corpora, models
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
import string

chapter_dir = os.path.expanduser("$CHAPTERS_DIR")
output_csv = os.path.expanduser("$CSV_OUT")

stop_words = set(stopwords.words("english"))
results = []

for fname in sorted(os.listdir(chapter_dir)):
    with open(os.path.join(chapter_dir, fname), encoding="utf-8") as f:
        text = f.read().lower()
        words = word_tokenize(text)
        words = [w for w in words if w not in stop_words and w not in string.punctuation and w.isalpha()]
        if len(words) < 20:
            continue

        dictionary = corpora.Dictionary([words])
        corpus = [dictionary.doc2bow(words)]
        lda = models.LdaModel(corpus, id2word=dictionary, num_topics=1, passes=5)
        top_topic = lda.print_topics(num_words=3)[0][1]
        results.append((fname, top_topic))

df = pd.DataFrame(results, columns=["chapter", "topic"])
df.to_csv(output_csv, index=False)
EOF

deactivate

# Paso 6: Validar resultado
if [ ! -s "$CSV_OUT" ]; then
    echo "❌ Error: El archivo $CSV_OUT no se generó correctamente o está vacío."
    exit 1
fi

echo "✅ Resultados guardados en: $CSV_OUT"
