import pandas as pd
import matplotlib.pyplot as plt
import os

# Cargar datos de personajes
df = pd.read_csv(os.path.expanduser('~/characters.csv'), names=['character', 'count'])

# Ordenar y graficar
df_sorted = df.sort_values(by='count', ascending=False)

plt.figure(figsize=(10, 6))
plt.bar(df_sorted['character'], df_sorted['count'], color='seagreen')
plt.title("Frecuency Characters'")
plt.xlabel("Character")
plt.ylabel("Mention")
plt.xticks(rotation=45)
plt.tight_layout()

# Guardar imagen
plt.savefig(os.path.expanduser('~/characters.png'))
