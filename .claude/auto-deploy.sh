#!/usr/bin/env bash
set -euo pipefail

REPO=/home/user/KI_News
cd "$REPO"

ORIG=$(git rev-parse --abbrev-ref HEAD)

# Nicht deployen wenn wir schon auf gh-pages sind
[ "$ORIG" = "gh-pages" ] && exit 0

# Nur relevant wenn index.html existiert
[ -f index.html ] || exit 0

# Aktuellen Stand von gh-pages holen
git fetch origin gh-pages --quiet 2>/dev/null || true

# Nichts tun wenn index.html auf gh-pages bereits identisch ist
if git diff --quiet origin/gh-pages -- index.html 2>/dev/null; then
    exit 0
fi

# Aktuelle index.html sichern
TMPFILE=$(mktemp /tmp/ki-news-XXXXXX.html)
cp index.html "$TMPFILE"

# gh-pages auschecken, Datei übernehmen, committen, pushen
git checkout gh-pages --quiet
cp "$TMPFILE" index.html
rm "$TMPFILE"

if ! git diff --quiet HEAD -- index.html; then
    git add index.html
    git commit -m "Deploy: sync index.html from ${ORIG} ($(date '+%Y-%m-%d %H:%M'))"
    git push origin gh-pages --quiet
fi

# Zurück zum ursprünglichen Branch
git checkout "$ORIG" --quiet

echo '{"systemMessage": "gh-pages aktualisiert ✓"}'
