import pandas as pd
import matplotlib.pyplot as plt
import os

# Leer CSV generado
df = pd.read_csv(os.path.expanduser('~/temas_mobydick.csv'))

# Extraer número de capítulo
df['capitulo'] = df['chapter'].str.extract(r'(\d+)').astype(int)

# Graficar temas
plt.figure(figsize=(12, 10))
plt.barh(df['capitulo'], df['topic'], color='lightgreen')
plt.xlabel("Temas (palabras más representativas)")
plt.ylabel("Capítulo")
plt.title("Evolución de Temas por Capítulo en 'Moby Dick'")
plt.tight_layout()

# Guardar imagen
plt.savefig(os.path.expanduser('~/temas_mobydick.png'))
