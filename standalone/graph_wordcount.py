import pandas as pd
import matplotlib.pyplot as plt
import os

# Leer CSV generado por Hadoop
df = pd.read_csv(os.path.expanduser('~/wordcount_mobydick.csv'), names=['word', 'count'])

# Ordenar por frecuencia
df_sorted = df.sort_values(by='count', ascending=False).head(20)

# Graficar
plt.figure(figsize=(12, 6))
plt.bar(df_sorted['word'], df_sorted['count'], color='skyblue')
plt.title("Top 20 Palabras más Frecuentes en 'Moby Dick'")
plt.xlabel("Palabra")
plt.ylabel("Frecuencia")
plt.xticks(rotation=45)
plt.tight_layout()

# Guardar correctamente en el home
output_path = os.path.expanduser('~/top_palabras_mobydick.png')
plt.savefig(output_path)