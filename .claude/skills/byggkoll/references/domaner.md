# Domänkontroller

Välj den eller de domäner som passar appen. Kontrollerna är utgångspunkter: anpassa dem till vad appen faktiskt gör och lägg till egna.

## Träning och hälsa
- Räknelogik: reps, set, vikter, streaks och totaler räknas rätt, utan dubbelräkning och utan att nollställas av misstag (ångra, omladdning, dagsskifte)
- Datum: dag, vecka och streak räknas i lokal tid och klarar midnatt, sommartid och månadsskiften
- Enheter: kg/lbs och km/miles blandas inte ihop, avrundning är rimlig
- Rimlighet: negativa värden, orimligt stora värden och tom indata hanteras
- Historik: data tappas inte vid omladdning, uppdatering eller full lagring
- Påminnelser och notiser fungerar på mobilen (iOS kräver installerad PWA; Android Chrome kräver service workerns showNotification i stället för `new Notification`)

## Kamera, mikrofon och rörelsedetektering
- Behörighet: appen frågar om tillgång, hanterar nej och visar vad användaren ska göra
- Kameran och mikrofonen stängs (alla tracks stoppas) när vyn lämnas, appen göms eller sidan stängs
- Fungerar på https (krävs för getUserMedia), med front- och bakkamera, och i både stående och liggande läge
- Detekteringslogik: tröskelvärden och utjämning, att en rörelse räknas exakt en gång (ingen dubbelräkning vid skakig bild), att räkningen inte startar av sig själv
- Prestanda: bildanalysen körs inte snabbare än nödvändigt, låser inte gränssnittet och dränerar inte batteriet
- Integritet: bilder och video skickas inte iväg eller sparas utan att användaren vet om det

## Matlagning och recept
- Portionsskalning: alla ingredienser skalas, bråk och decimaler blir rimliga (inte "0.3333 ägg")
- Enhetsomvandling: dl, msk, tsk, g, ml, cups, oz omvandlas rätt; volym och vikt blandas inte utan omvandlingsfaktor per ingrediens
- Tider: tillagnings- och timertider summeras rätt, timers överlever att skärmen släcks
- Inköpslista: dubbletter slås ihop, enheter matchas
- Allergener och kost (gluten, laktos, vegetariskt) markeras konsekvent

## Ekonomi, budget och betalning
- Belopp räknas inte med flyttal på ett sätt som ger öresfel (använd heltal i ören/cent eller decimalbibliotek)
- Valuta och avrundning är konsekvent, moms beräknas rätt
- Betalningsflöden: dubbla tryck ger inte dubbel betalning, fel och avbrott hanteras
- Hemligheter (API-nycklar, betalnycklar) ligger inte i klientkoden

## Bokning, kalender och schema
- Tidszoner, sommartid och veckostart (måndag i Sverige)
- Dubbelbokning och överlappande tider förhindras
- Datumformat och lokal visning (sv-SE)

## Spel
- Poäng, nivåer och highscore sparas och räknas rätt
- Spelloopen är oberoende av bildfrekvens (använder delta-tid)
- Paus vid dold flik, ljud stoppas, inga minnesläckor vid omstart

## Lista, anteckningar och uppgifter
- Data försvinner inte vid redigering, sortering eller borttagning (ångra eller bekräftelse)
- Sök och filter hanterar å, ä, ö och versaler

## Formulär, konton och inloggning
- Validering både i klient och server, tydliga felmeddelanden
- Lösenord och tokens loggas eller lagras inte i klartext
- Utloggning rensar känslig data

## Webbplats och landningssida (t.ex. för företag)
- Alla länkar, bilder och kontaktuppgifter fungerar
- Titel, metabeskrivning och språk (`lang="sv"`) är satta
- Fungerar på mobil, laddar snabbt, bilder har alt-text
- Kontaktformulär skickar faktiskt och ger bekräftelse

## PWA och offline (gäller utöver appens domän)
- Alla filer som service workern cachar finns, sökvägarna är relativa om appen kan ligga i en undermapp
- Cacheversionen höjs när cachade filer ändras
- Manifestets färger och ikoner stämmer med appen, iOS-ikon är PNG

## Övrigt
Passar ingen domän: beskriv vad appen gör, fråga dig vad som skulle göra användaren mest besviken om det gick fel, och granska det först.
