#!/bin/bash

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

# Activar entorno virtual
source "$HOME/venv_hadoop/bin/activate"

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

# Ejecutar script de visualización
if [ -f "$HOME/easy_hadoop/standalone/graph_topics.py" ]; then
    python "$HOME/easy_hadoop/standalone/graph_topics.py"
else
    echo "❌ No se encontró graph_topics.py"
fi

deactivate
echo "✅ Análisis completado. Verifica ~/topics.png"
