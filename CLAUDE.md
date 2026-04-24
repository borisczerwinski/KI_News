# KI_News – Projektregeln für Claude

## Branch-Strategie

**Alle Änderungen gehen direkt in `main`.**

- Beim Sessionstart sofort auf `main` wechseln: `git checkout main && git pull origin main`
- Commits direkt auf `main` pushen: `git push origin main`
- Keine Feature-Branches erstellen
- gh-pages wird automatisch über den PostToolUse-Hook nach jedem Commit aktualisiert (`.claude/auto-deploy.sh`)

## Projektstruktur

- `index.html` – KI-News-Dashboard (einzige Hauptdatei)
- `.claude/auto-deploy.sh` – deployt `index.html` automatisch nach `gh-pages`
- `.claude/settings.json` – Hook-Konfiguration

## Deployment

Nach jedem `git commit` auf `main` läuft der Hook automatisch:
1. Vergleicht `index.html` mit dem Stand auf `origin/gh-pages`
2. Wenn geändert: checkt `gh-pages` aus, übernimmt die Datei, committed und pushed
3. Kehrt zu `main` zurück

## Pflichtregeln beim Bearbeiten von index.html

**NIEMALS `Write` für index.html verwenden.** Die Datei ist zu groß für einen einzelnen Write-Aufruf – das löst einen API-Stream-Idle-Timeout aus.

Stattdessen immer diesen Ablauf einhalten:

### 1. Recherche vollständig abschließen, bevor geschrieben wird
Alle `WebSearch`-Aufrufe zuerst parallel ausführen und alle Ergebnisse sichten. Erst danach mit dem Editieren beginnen.

### 2. index.html ausschließlich per Edit aktualisieren
Jede Änderung als eigenen, kleinen `Edit`-Aufruf umsetzen – nie alles auf einmal:
- Header (Titel, Datum) → 1 Edit
- Stats-Leiste → 1 Edit
- Jede neue Artikel-Karte → 1 Edit (einfügen oder ersetzen)
- Zu entfernende Karten → je 1 Edit
- Footer → 1 Edit

### 3. Reihenfolge beim News-Update
1. Alle WebSearch-Calls parallel abfeuern
2. Ergebnisse auswerten, Artikelliste zusammenstellen
3. Header-Datum aktualisieren (Edit)
4. Stats aktualisieren (Edit)
5. Claude-Sektion: alte Karten ersetzen (je 1 Edit pro Karte)
6. Allgemeine Sektion: alte Karten ersetzen (je 1 Edit pro Karte)
7. Footer aktualisieren (Edit)
8. `git add index.html && git commit` → löst Auto-Deploy aus
