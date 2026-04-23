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
