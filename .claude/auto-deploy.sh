#!/usr/bin/env bash
set -e

cd /home/user/KI_News

BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Commit any uncommitted changes
if ! git diff --quiet || ! git diff --cached --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
  git add -A
  git commit -m "Auto-update: $(date '+%Y-%m-%d %H:%M')"
fi

# Push working branch
git push -u origin "$BRANCH"

# Merge into gh-pages and push
git checkout gh-pages
git merge "$BRANCH" --no-edit
git push -u origin gh-pages

# Switch back
git checkout "$BRANCH"

echo '{"systemMessage": "Deployed to GitHub Pages (gh-pages branch updated)"}'
