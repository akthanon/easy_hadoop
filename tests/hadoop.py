import collections
import matplotlib.pyplot as plt
import re

def contar_palabras(nombre_archivo, top_n=10):
    # Leer archivo
    with open(nombre_archivo, 'r', encoding='utf-8') as f:
        texto = f.read().lower()

    # Limpiar texto y separar palabras
    palabras = re.findall(r'\b\w+\b', texto)

    # Contar palabras
    total_palabras = len(palabras)
    contador = collections.Counter(palabras)

    print(f"Total de palabras: {total_palabras}\n")
    print(f"Top {top_n} palabras más frecuentes:")
    for palabra, frecuencia in contador.most_common(top_n):
        print(f"{palabra}: {frecuencia}")

    # Gráfica de barras
    palabras_comunes = contador.most_common(top_n)
    etiquetas, valores = zip(*palabras_comunes)

    plt.figure(figsize=(10, 5))
    plt.bar(etiquetas, valores, color='skyblue')
    plt.title(f"Top {top_n} palabras más frecuentes")
    plt.xlabel("Palabras")
    plt.ylabel("Frecuencia")
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.show()

# Reemplaza 'archivo.txt' por la ruta a tu archivo
contar_palabras('archivo.txt', top_n=10)
