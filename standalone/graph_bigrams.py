import pandas as pd
import matplotlib.pyplot as plt
import os

# Leer CSV de bigramas
df = pd.read_csv(os.path.expanduser('~/bigrams_mobydick.csv'), names=['bigram', 'count'])

# Ordenar y graficar top 20
df_sorted = df.sort_values(by='count', ascending=False).head(20)

plt.figure(figsize=(14, 6))
plt.bar(df_sorted['bigram'], df_sorted['count'], color='coral')
plt.title("Top 20 Bigramas más Frecuentes en 'Moby Dick'")
plt.xlabel("Bigramas")
plt.ylabel("Frecuencia")
plt.xticks(rotation=45)
plt.tight_layout()

# Guardar
plt.savefig(os.path.expanduser('~/top_bigrams_mobydick.png'))
