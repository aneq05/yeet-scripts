#!/usr/bin/env bash
set -euo pipefail

declare -A blocks=()
duplicate_count=0

while IFS= read -r -d '' file; do
  window=()

  while IFS= read -r line || [ -n "$line" ]; do
    line="$(sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//' <<<"$line")"

    [[ -z "$line" ]] && continue
    [[ "$line" =~ ^#include[[:space:]] ]] && continue
    [[ "$line" =~ ^// ]] && continue
    [[ "$line" =~ ^namespace[[:space:]] ]] && continue
    case "$line" in
      "{"|"}"|"};"|";") continue ;;
    esac

    window+=("$line")
    if ((${#window[@]} == 4)); then
      key="$(printf '%s\n' "${window[@]}")"
      if [[ -n "${blocks[$key]:-}" ]]; then
        duplicate_count=$((duplicate_count + 1))
      else
        blocks["$key"]=1
      fi
      window=("${window[@]:1}")
    fi
  done <"$file"
done < <(find include src tests -type f \( -name '*.h' -o -name '*.cpp' \) -print0)

if ((duplicate_count > 0)); then
  printf 'Found %s duplicated non-empty line(s)\n' "$duplicate_count" >&2
  exit 1
fi

printf 'No duplicated non-empty lines found\n'
