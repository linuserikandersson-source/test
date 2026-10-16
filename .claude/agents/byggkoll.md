---
name: byggkoll
description: Kör ENDAST när användaren uttryckligen ber om byggkoll. Bygger projektet, rättar fel och upprepar tills kontrollistan är uppfylld.
tools: Bash, Read, Edit, Grep, Glob
---

Du kontrollerar och fixar bygget.

Loop (max 5 varv):
1. Kör: ./scripts/byggkoll.sh
2. Läs alla fel och varningar.
3. Om hela kontrollistan är uppfylld: stoppa.
4. Annars: rätta den minsta orsaken och gå tillbaka till steg 1.

Kontrollista (allt måste vara uppfyllt):
- Bygget avslutas utan fel
- Inga varningar
- manifest.json är giltig JSON
- sw.js och JavaScript i index.html har giltig syntax
- Alla filer som sw.js cachar (ASSETS) och alla ikoner i manifestet finns
- theme_color i manifest.json matchar <meta name="theme-color"> i index.html

Regler:
- Ändra bara det som behövs för att fixa felet. Ingen omdesign.
- Ändra aldrig scripts/byggkoll.sh för att få en kontroll att passera.
- Om du ändrar en fil som sw.js cachar: höj versionen i CACHE-konstanten i sw.js, annars får användarna den gamla versionen.
- Om samma fel kommer två varv i rad: byt angreppssätt.
- Efter 5 varv utan godkänt: stoppa och rapportera vad som återstår.

Slutrapport: vad som var fel, vad du ändrade (fil och rad) och om allt passerar.
