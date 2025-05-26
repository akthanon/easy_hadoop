#!/bin/bash

# Verificar dependencias
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

pip install matplotlib pandas --quiet

# Ejecutar gráfico
python "$HOME/easy_hadoop/standalone/graph_characters.py" || python "$HOME/graph_characters.py"

deactivate
echo "✅ Gráfico generado. Verifica ~/personajes_mobydick.png"
