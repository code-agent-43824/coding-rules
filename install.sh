#!/usr/bin/env bash
# Кладёт свод правил в текущий репозиторий: скачивает AGENTS.md и подключает его
# импортом из CLAUDE.md. Идемпотентен — можно запускать повторно для обновления.
#
#   curl -fsSL https://raw.githubusercontent.com/code-agent-43824/coding-rules/main/install.sh | bash

set -euo pipefail

RAW_URL="https://raw.githubusercontent.com/code-agent-43824/coding-rules/main/AGENTS.md"
IMPORT_LINE='@AGENTS.md'

if [ ! -d .git ]; then
  echo "Ошибка: $(pwd) — не корень git-репозитория." >&2
  exit 1
fi

curl -fsSL "$RAW_URL" -o AGENTS.md
echo "AGENTS.md   — записан, $(wc -l < AGENTS.md) строк"

if [ ! -f CLAUDE.md ]; then
  printf '%s\n' "$IMPORT_LINE" > CLAUDE.md
  echo "CLAUDE.md   — создан с импортом"
elif grep -qxF "$IMPORT_LINE" CLAUDE.md; then
  echo "CLAUDE.md   — импорт уже на месте"
else
  printf '%s\n\n' "$IMPORT_LINE" | cat - CLAUDE.md > CLAUDE.md.tmp
  mv CLAUDE.md.tmp CLAUDE.md
  echo "CLAUDE.md   — импорт добавлен первой строкой"
fi

echo
echo "Осталось закоммитить:"
echo "  git add AGENTS.md CLAUDE.md && git commit -m 'chore: update agent rules' && git push"
