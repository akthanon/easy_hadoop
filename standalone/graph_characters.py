import pandas as pd
import matplotlib.pyplot as plt
import os

# Cargar datos de personajes
df = pd.read_csv(os.path.expanduser('~/personajes_mobydick.csv'), names=['personaje', 'count'])

# Ordenar y graficar
df_sorted = df.sort_values(by='count', ascending=False)

plt.figure(figsize=(10, 6))
plt.bar(df_sorted['personaje'], df_sorted['count'], color='seagreen')
plt.title("Frecuencia de Mención de Personajes en 'Moby Dick'")
plt.xlabel("Personaje")
plt.ylabel("Menciones")
plt.xticks(rotation=45)
plt.tight_layout()

# Guardar imagen
plt.savefig(os.path.expanduser('~/personajes_mobydick.png'))
