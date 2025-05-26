#!/bin/bash

# Verificar dependencias necesarias
if ! dpkg -s python3-pip &>/dev/null; then
    echo "Instalando python3-pip..."
    sudo apt update
    sudo apt install python3-pip -y
fi

if ! dpkg -s python3-venv &>/dev/null; then
    echo "Instalando python3-venv..."
    sudo apt update
    sudo apt install python3-venv -y
fi

# Crear entorno virtual
if [ ! -d "$HOME/venv_hadoop" ]; then
    python3 -m venv "$HOME/venv_hadoop"
fi

source "$HOME/venv_hadoop/bin/activate"

pip install matplotlib pandas textblob --quiet
python3 -m textblob.download_corpora

# Ejecutar script de análisis
python "$HOME/easy_hadoop/standalone/graph_feelings.py" || python "$HOME/graph_feelings.py"

deactivate
echo "✅ Análisis completado. Verifica ~/sentimientos_mobydick.png"
