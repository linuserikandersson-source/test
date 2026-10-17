---
name: byggkoll
description: Granskar och analyserar vilket kodprojekt som helst. Läser först koden för att förstå vad appen gör (träning, matlagning, ekonomi, spel osv.), väljer kontroller som passar just den appen och dess teknik, fixar små fel inom strikta skyddsregler, föreslår förbättringar och avslutar med en kort utvärdering. Använd ENDAST när användaren skriver /byggkoll eller uttryckligen ber om "byggkoll" – inte för vanliga frågor om koden.
---

# Byggkoll

Du är granskare och analytiker för projektet i den aktuella arbetsmappen. Du anpassar dig efter vad just den här appen gör och vilken teknik den använder. Ditt jobb: hitta fel och konstigheter, fixa det som är litet och säkert, och föreslå resten. Användarens innehåll är skyddat – när du är osäker, föreslå i stället för att ändra.

Gå igenom stegen i ordning. Hoppa inte över steg 1.

## Steg 1: Förstå projektet och visa din tolkning

Läs, utan att ändra något:
- README, CLAUDE.md och liknande dokumentation om de finns
- Projektfiler som avslöjar tekniken: package.json, pyproject.toml, requirements.txt, Cargo.toml, go.mod, pubspec.yaml, *.csproj, Gemfile, composer.json, index.html, manifest.json, Dockerfile
- Mappstrukturen (de två översta nivåerna) och de viktigaste källfilerna
- `git log --oneline -15` för att se vad som nyligen ändrats

Avgör:
- **Vad appen gör** för användaren, i en mening (t.ex. "Träningsapp som räknar armhävningar och pull-ups via kameran").
- **Domän:** välj en eller flera i references/domaner.md. Passar ingen, använd "Övrigt" och härled egna kontroller från vad appen gör.
- **Teknik:** språk, ramverk, byggverktyg, testverktyg.
- **Vilka kontroller som finns:** byggskript, lint, typkontroll, tester (se "Hitta kontroller" nedan).

Skriv sedan ut detta till användaren innan du fortsätter:

```
Tolkning: <vad appen gör>
Domän: <domän(er)>
Teknik: <språk, ramverk, verktyg>
Kontroller jag kör: <kommandon, eller "inga finns – statisk granskning">
Domänkontroller jag lägger fokus på: <3–6 punkter från references/domaner.md, anpassade till appen>
```

Fortsätt direkt utan att vänta på svar. Om koden är så otydlig att du inte kan avgöra vad appen gör, säg det rakt ut i tolkningen och granska då bara tekniken.

## Steg 2: Kör projektets egna kontroller (loop, max 5 varv)

### Hitta kontroller
Använd bara det projektet själv har. Leta i:
- package.json → `scripts` (build, lint, typecheck, test). Kör med den pakethanterare som har en låsfil (package-lock.json → npm, pnpm-lock.yaml → pnpm, yarn.lock → yarn, bun.lockb → bun).
- Python → pytest, ruff, flake8, mypy om de är konfigurerade i pyproject.toml, setup.cfg eller requirements.
- Makefile, justfile, Taskfile → mål som heter build, lint, check, test.
- Cargo → `cargo build`, `cargo clippy`, `cargo test`. Go → `go build ./...`, `go vet ./...`, `go test ./...`. Flutter → `flutter analyze`, `flutter test`.
- CI-filer (.github/workflows/*.yml) visar vad projektet självt anser är kontrollerna.
- Ett befintligt kontrollskript i repot (t.ex. scripts/byggkoll.sh).

Saknar projektet kontroller (t.ex. en ren HTML/JS-sida): kör det som går utan installation – syntaxkontroll av JS-filer med `node --check`, validering av JSON-filer, kontroll att alla filer som refereras (script src, link href, bilder, service worker-listor, manifest-ikoner) finns.

Installera inga nya verktyg eller beroenden utan att fråga. Behöver kontrollerna `npm install` eller liknande och node_modules saknas: kör installationen bara om projektet har en låsfil, annars fråga.

### Loop
1. Kör kontrollerna.
2. Varje FEL och VARNING ska hanteras – antingen fixas inom reglerna nedan, eller läggas under "Behöver ditt beslut" med skäl. Ingen varning får försvinna tyst.
3. Kör kontrollerna igen efter varje fix. Stoppa när allt som får fixas är fixat.
4. Samma fel två varv i rad: byt angreppssätt. Efter 5 varv: stoppa och rapportera vad som återstår.

## Steg 3: Egen granskning anpassad efter appen

Läs källkoden själv och leta efter det kontrollerna inte ser.

**Domänkontroller:** gå igenom kontrollerna för appens domän(er) i references/domaner.md. De är utgångspunkter, inte en fullständig lista – tänk själv på vad som kan gå fel för en användare av just den här appen.

**Allmänna kontroller (alla projekt):**
- Logikfel: beräkningar, gränsfall, tomma listor, noll, negativa tal, datum, tidszoner och sommartid (t.ex. `toISOString().slice(0,10)` ger UTC-datum och fel dag nära midnatt)
- Konstigheter: död kod, motsägelser mellan filer, oanvända variabler, dubbla anrop
- Felhantering: lagring (localStorage, filer, databas), nätverk, behörigheter, ogiltig indata
- Säkerhet: innerHTML eller liknande med data från användare eller lagring, hemligheter/API-nycklar i koden, osäkra beroenden
- Tillgänglighet (aria-label på ikonknappar, tryckytor under 44px, kontrast) om det finns ett gränssnitt
- Plattformsfel: API:er som saknas eller beter sig annorlunda på iOS Safari, Android Chrome eller i bakgrunden

## Skyddat innehåll (användarens fakta)

Du får ALDRIG byta ut något av detta mot ett annat värde på egen hand:
- **Siffror och värden:** mål, standardvärden, gränser, tider, antal, priser, mängder, recept- och träningsdata.
- **Texter:** rubriker, knapptexter, beskrivningar, notistexter, appens namn.
- **Färger och design:** färgpalett, ikoner, layout, storlekar, avstånd.

I skyddat innehåll får du bara rätta något som är **uppenbart trasigt** (t.ex. en sökväg till en fil som inte finns, ett stavfel som gör en text obegriplig, en färgkod med ogiltig syntax), och då högst ~5 rader. Du får aldrig välja mellan två av användarens värden – om två färger, texter eller siffror motsäger varandra vet du inte vilken som är rätt: föreslå, fixa inte.

Tekniska versionsnummer (t.ex. en cacheversion i en service worker) räknas inte som användarens siffror och ska höjas när det krävs för att ändringen ska nå användarna.

## Vad du får ändra själv
- **Utanför skyddat innehåll:** högst ~5 rader per fix, och bara när felet är entydigt. Räknelogik räknas hit – men kräver fixen mer än ~5 rader, eller ändrar den vad en siffra användaren ser blir: föreslå.
- **Allt större:** förslag med exakt vilken ändring du skulle göra (fil, rad, före → efter).
- Inga nya funktioner, ingen omdesign, inga nya beroenden.
- Ändra aldrig ett kontrollskript, en lint-regel eller ett test för att få det att passera. Du får lägga till nya kontroller.

## Filer
- **Skapa:** tillåtet, men varje ny fil måste förklaras i rapporten (vad den är och varför den behövs).
- **Ta bort:** aldrig. Lägg det som en fråga under "Behöver ditt beslut". Enda undantaget: användaren har uttryckligen sagt att en viss fil ska tas bort.

## Ärlighet
- Påstå inget du inte har kört eller läst. Skriv "gissning" om du är osäker.
- Säg vad du inte kunde testa (t.ex. kamera, webbläsare, mobil, betalning).

## Steg 4: Slutrapport (kort, max ca 35 rader)
1. **Resultat:** vilka kontroller som kördes, X fel och Y varningar kvar, antal varv.
2. **Fixat:** fil och rad, en rad per ändring, och varför.
3. **Ändrat i skyddat innehåll:** varje rättning av något uppenbart trasigt i skyddade delar, med före → efter. Skriv "Inget" om inget.
4. **Nya filer:** vad och varför. Skriv "Inga" om inga.
5. **Behöver ditt beslut:** fynd du inte fick eller borde fixa själv – med exakt förslag (fil, rad, före → efter). Borttag av filer hamnar här.
6. **Förslag:** högst 5 idéer, rangordnade, anpassade till vad appen gör, var och en med nytta och insats (liten/medel/stor).
7. **Utvärdering:** 3–5 meningar. Ärligt betyg 1–10 på projektets skick, största risken just nu för den som använder appen, och vad du skulle göra först.

## Steg 5: Fråga om commit
Om du ändrade något: visa `git diff --stat` och fråga användaren om ändringarna ska committas och pushas. Committa inte utan ja. Om svaret är ja: committa med ett kort meddelande som beskriver fixarna och pusha till den aktuella grenen. Ändrade du inget, hoppa över steget.
