import pandas as pd
import matplotlib.pyplot as plt
import os

# Leer CSV generado por Hadoop
df = pd.read_csv(os.path.expanduser('~/wordcount.csv'), names=['word', 'count'])

# Ordenar por frecuencia
df_sorted = df.sort_values(by='count', ascending=False).head(20)

# Graficar
plt.figure(figsize=(12, 6))
plt.bar(df_sorted['word'], df_sorted['count'], color='skyblue')
plt.title("Top 20 Wordcount'")
plt.xlabel("Word")
plt.ylabel("Count")
plt.xticks(rotation=45)
plt.tight_layout()

# Guardar correctamente en el home
output_path = os.path.expanduser('~/top_wordcount.png')
plt.savefig(output_path)