import pandas as pd
import matplotlib.pyplot as plt
import re
import os

csv_path = os.path.expanduser('~/temas_mobydick.csv')
df = pd.read_csv(csv_path)

# Extraer palabras y pesos del campo 'topic'
def parse_topic(topic_str):
    # topic_str ejemplo: '0.021*"whale" + 0.007*"whales" + 0.006*"one"'
    parts = re.findall(r'([\d\.]+)\*"\s*([^"]+)"', topic_str.replace(' ', ''))
    return [(word, float(weight)) for weight, word in parts]

# Construir un dataframe con filas capítulos y columnas palabras
all_words = set()
parsed_topics = []

for idx, row in df.iterrows():
    parsed = parse_topic(row['topic'])
    parsed_topics.append(parsed)
    for word, _ in parsed:
        all_words.add(word)

all_words = sorted(all_words)

# Crear dataframe vacío con ceros
topic_weights = pd.DataFrame(0.0, index=df['chapter'], columns=all_words, dtype=float)

# Rellenar con pesos
for i, chapter in enumerate(df['chapter']):
    for word, weight in parsed_topics[i]:
        topic_weights.at[chapter, word] = weight

# Seleccionar las palabras más comunes para graficar (ej. top 10 sumando pesos)
top_words = topic_weights.sum(axis=0).sort_values(ascending=False).head(10).index

plt.figure(figsize=(14, 8))
for word in top_words:
    plt.plot(topic_weights.index, topic_weights[word], marker='o', label=word)

plt.xticks(rotation=90)
plt.title('Evolución de temas (palabras clave) por capítulo en Moby Dick')
plt.xlabel('Capítulo')
plt.ylabel('Peso del tópico LDA')
plt.legend()
plt.tight_layout()

output_path = os.path.expanduser('~/temas_mobydick.png')
plt.savefig(output_path)
print(f'✅ Gráfica guardada en {output_path}')
