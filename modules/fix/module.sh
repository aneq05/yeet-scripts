#!/usr/bin/env bash

yeet_fix_main() {
  local target="${1:-}"
  [ -n "$target" ] || yeet_die "Usage: yeet <project> fix <whitespaces>"
  shift || true

  case "$target" in
    whitespace|whitespaces)
      yeet_fix_whitespaces "$@"
      ;;
    *)
      yeet_die "Unknown fix target: $target"
      ;;
  esac
}

yeet_fix_whitespaces() {
  local root="${YEET_PROJECT_ROOT:-$PWD}"
  local paths=("$@")
  [ "${#paths[@]}" -gt 0 ] || paths=(".")

  yeet_note "fix whitespaces"
  (
    cd "$root"
    while IFS= read -r -d '' file; do
      case "$file" in
        */.git/*|*/node_modules/*|*/build/*|*/dist/*) continue ;;
      esac
      perl -0pi -e 's/[ \t]+(\r?\n)/$1/g' "$file"
    done < <(find "${paths[@]}" -type f -print0)
  )
}
