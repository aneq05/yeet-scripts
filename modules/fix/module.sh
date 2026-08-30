#!/usr/bin/env bash

yeet_fix_main() {
  local target="${1:-}"
  if yeet_is_help_request "$target" || [ -z "$target" ]; then
    cat <<'EOF'
Usage:
  yeet <project> fix <whitespaces> [paths...]

Example:
  yeet my-app fix whitespaces src tests
EOF
    [ -n "$target" ]
    return
  fi
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
    yeet_require_existing_paths "${paths[@]}"
    while IFS= read -r -d '' file; do
      yeet_should_skip_path "$file" && continue
      yeet_is_text_file "$file" || continue
      perl -0pi -e 's/[ \t]+(\r?\n)/$1/g' "$file"
    done < <(find "${paths[@]}" -type f -print0)
  )
}
