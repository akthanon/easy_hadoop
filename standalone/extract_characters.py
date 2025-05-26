# extract_characters.py
import spacy
from collections import Counter

# Carga del modelo en inglés
nlp = spacy.load("en_core_web_sm")

# Leer el texto
with open("book.txt", "r", encoding="utf-8") as f:
    text = f.read()

# Procesamiento
doc = nlp(text)

# Extraer entidades nombradas tipo PERSON
names = [ent.text for ent in doc.ents if ent.label_ == "PERSON"]

# Contar frecuencia
name_counts = Counter(names)

# Filtrar los más frecuentes
common_names = [name for name, count in name_counts.items() if count > 5]

# Salida como patrón de grep
grep_pattern = "|".join(sorted(set(common_names)))
print(grep_pattern)
