#!/usr/bin/env bash

yeet_check_main() {
  local check="${1:-}"
  if yeet_is_help_request "$check" || [ -z "$check" ]; then
    cat <<'EOF'
Usage:
  yeet <project> check <cpd|whitespaces> [paths...]

Examples:
  yeet my-app check cpd
  yeet my-app check whitespaces src tests
EOF
    [ -n "$check" ]
    return
  fi
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
    local found=0 lines_file
    lines_file="$(mktemp)"
    yeet_require_existing_paths "${paths[@]}"
    while IFS= read -r -d '' file; do
      yeet_should_skip_path "$file" && continue
      yeet_is_text_file "$file" || continue
      if grep -n '[[:blank:]]$' "$file" >"$lines_file" 2>/dev/null; then
        sed "s#^#$file:#" "$lines_file"
        found=1
      fi
    done < <(find "${paths[@]}" -type f -print0)
    rm -f "$lines_file"
    [ "$found" -eq 0 ]
  )
}
