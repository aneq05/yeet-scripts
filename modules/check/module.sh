#!/usr/bin/env bash

yeet_check_main() {
  local check="${1:-}"
  [ -n "$check" ] || yeet_die "Usage: yeet <project> check <cpd|whitespaces>"
  shift || true

  case "$check" in
    cpd)
      yeet_check_cpd "$@"
      ;;
    whitespace|whitespaces)
      yeet_check_whitespaces "$@"
      ;;
    *)
      yeet_die "Unknown check: $check"
      ;;
  esac
}

yeet_check_cpd() {
  if [ -n "${YEET_CPD:-}" ]; then
    yeet_run_shell "$YEET_CPD" "check cpd"
    return
  fi

  yeet_run_shell "npx --yes jscpd ." "check cpd"
}

yeet_check_whitespaces() {
  local root="${YEET_PROJECT_ROOT:-$PWD}"
  local paths=("$@")
  [ "${#paths[@]}" -gt 0 ] || paths=(".")

  yeet_note "check whitespaces"
  (
    cd "$root"
    local found=0
    while IFS= read -r -d '' file; do
      case "$file" in
        */.git/*|*/node_modules/*|*/build/*|*/dist/*) continue ;;
      esac
      if grep -nI '[[:blank:]]$' "$file" >/tmp/yeet-ws-lines 2>/dev/null; then
        sed "s#^#$file:#" /tmp/yeet-ws-lines
        found=1
      fi
    done < <(find "${paths[@]}" -type f -print0)
    rm -f /tmp/yeet-ws-lines
    [ "$found" -eq 0 ]
  )
}
