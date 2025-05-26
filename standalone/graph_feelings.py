import pandas as pd
import matplotlib.pyplot as plt
import os

# Leer datos
df = pd.read_csv(os.path.expanduser('~/feelings.csv'))

# Ordenar por capítulo
df['capitulo'] = df['chapter'].str.extract(r'(\d+)').astype(int)
df = df.sort_values(by='capitulo')

# Graficar
plt.figure(figsize=(14, 6))
plt.plot(df['capitulo'], df['polarity'], marker='o', linestyle='-', color='purple')
plt.axhline(0, color='gray', linestyle='--', linewidth=0.8)
plt.title("Analisys per Chapter")
plt.xlabel("Chapter")
plt.ylabel("Polar (−1 negative, +1 positive)")
plt.grid(True)
plt.tight_layout()

# Guardar imagen
plt.savefig(os.path.expanduser('~/feelings.png'))
