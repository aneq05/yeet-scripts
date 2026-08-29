#!/usr/bin/env bash

yeet_die() {
  printf 'yeet: %s\n' "$*" >&2
  exit 1
}

yeet_note() {
  printf '=> %s\n' "$*" >&2
}

yeet_usage() {
  cat <<'EOF'
yeet-scripts

Usage:
  yeet modules
  yeet <project> <module> <command> [args...]
  yeet <module> <command> [args...]

Examples:
  yeet my-app build app
  yeet my-app run ut
  yeet my-app check cpd
  yeet my-app check whitespaces
  yeet my-app fix whitespaces
  yeet my-app coverage
  yeet commit format feat auth add login validation
EOF
}

yeet_is_help_request() {
  case "${1:-}" in
    -h|--help|help) return 0 ;;
    *) return 1 ;;
  esac
}

yeet_list_modules() {
  local module_file module
  for module_file in "$YEET_ROOT"/modules/*/module.sh; do
    [ -f "$module_file" ] || continue
    module="$(basename "$(dirname "$module_file")")"
    printf '%s\n' "$module"
  done | sort
}

yeet_module_exists() {
  [ -f "$YEET_ROOT/modules/$1/module.sh" ]
}

yeet_upper_key() {
  printf '%s' "$1" | tr '[:lower:]-' '[:upper:]_'
}

yeet_should_skip_path() {
  case "$1" in
    ./.git/*|*/.git/*|\
    ./node_modules/*|*/node_modules/*|\
    ./build/*|*/build/*|\
    ./dist/*|*/dist/*|\
    ./.yeet/*|*/.yeet/*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

yeet_is_text_file() {
  grep -Iq . "$1" 2>/dev/null
}

yeet_load_project() {
  local project="$1"
  local project_file="$YEET_ROOT/projects/$project.env"

  [ -f "$project_file" ] || yeet_die "Missing project config: projects/$project.env"

  # shellcheck source=/dev/null
  source "$project_file"

  export YEET_PROJECT_NAME="$project"
  export YEET_PROJECT_ROOT="${YEET_PROJECT_ROOT:-$PWD}"
  export YEET_STORE_COMMAND_OUTPUT="${YEET_STORE_COMMAND_OUTPUT:-false}"
}

yeet_run_shell() {
  local command="$1"
  local label="${2:-command}"
  local root="${YEET_PROJECT_ROOT:-$PWD}"

  yeet_note "$label"
  yeet_note "$command"

  if [ "${YEET_STORE_COMMAND_OUTPUT:-false}" = "true" ]; then
    local log_dir="$YEET_ROOT/.yeet/logs"
    mkdir -p "$log_dir"
    (
      cd "$root"
      bash -lc "$command"
    ) 2>&1 | tee "$log_dir/${YEET_PROJECT_NAME:-global}-$(date +%Y%m%d-%H%M%S).log"
    return "${PIPESTATUS[0]}"
  fi

  (
    cd "$root"
    bash -lc "$command"
  )
}

yeet_run_configured() {
  local variable="$1"
  local label="${2:-$1}"
  local command="${!variable:-}"

  [ -n "$command" ] || yeet_die "Missing command in project config: $variable"
  yeet_run_shell "$command" "$label"
}
