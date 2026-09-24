#!/usr/bin/env bash
# Механические проверки свода. §2 требует, чтобы проверяемый машинно факт сторожил
# тест, а не дисциплина, — это он и есть.
#
#   ./check.sh

set -uo pipefail
cd "$(dirname "$0")"

fail=0
ok()   { printf '  ok   %s\n' "$1"; }
bad()  { printf '  FAIL %s\n' "$1"; fail=1; }
skip() { printf '  skip %s\n' "$1"; }

echo "1. Размер свода"
lines=$(wc -l < AGENTS.md)
if [ "$lines" -le 200 ]; then ok "AGENTS.md: $lines строк (потолок 200)"
else bad "AGENTS.md: $lines строк, потолок 200"; fi

echo "2. Перекрёстные ссылки внутри свода"
for ref in $(grep -o '§[0-9]\+' AGENTS.md | sort -u); do
  n=${ref#§}
  if grep -q "^## $n\. " AGENTS.md; then ok "$ref"; else bad "$ref — раздела нет"; fi
done

echo "3. Markdown-ссылки указывают на существующие файлы"
# Проверяются только настоящие ссылки [текст](путь). Упоминания в обратных кавычках —
# это проза, она называет файлы других проектов и существовать здесь не обязана.
# AGENTS.md исключён по §0: он копируется как есть и называет файлы, которых тут нет.
found=0
for f in $(ls *.md | grep -v '^AGENTS\.md$'); do
  while read -r target; do
    [ -z "$target" ] && continue
    case "$target" in http*|\#*) continue;; esac
    found=$((found+1))
    [ -e "${target%%#*}" ] || bad "$f -> $target"
  done < <(grep -oE '\]\([^)]+\)' "$f" | sed 's/^](//; s/)$//')
done
[ "$fail" -eq 0 ] && ok "проверено ссылок: $found"

echo "4. install.sh"
if bash -n install.sh 2>/dev/null; then ok "синтаксис"; else bad "синтаксис"; fi
slug=$(git remote get-url origin 2>/dev/null \
  | sed -nE 's#.*github\.com[:/]([^/]+/[^/]+?)(\.git)?/?$#\1#p')
if [ -n "$slug" ]; then
  grep -q "$slug" install.sh && ok "url ведёт на $slug" || bad "url в install.sh не на $slug"
else
  skip "origin не задан — url не сверить"
fi

tmp=$(mktemp -d)
if git init -q "$tmp" 2>/dev/null && (cd "$tmp" && bash "$OLDPWD/install.sh" >/dev/null 2>&1); then
  if [ -s "$tmp/AGENTS.md" ] && [ "$(head -1 "$tmp/CLAUDE.md")" = '@AGENTS.md' ]; then
    ok "прогон в чистом репозитории"
  else
    bad "прогон в чистом репозитории: файлы не на месте"
  fi
else
  skip "прогон в чистом репозитории (нет сети или git)"
fi
rm -rf "$tmp"

echo
[ "$fail" -eq 0 ] && echo "Всё зелено." || echo "Есть провалы."
exit "$fail"
