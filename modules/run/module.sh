#!/usr/bin/env bash

yeet_run_main() {
  local target="${1:-}"
  if yeet_is_help_request "$target" || [ -z "$target" ]; then
    cat <<'EOF'
Usage:
  yeet <project> run <target>

Examples:
  yeet my-app run app
  yeet my-app run ut
EOF
    [ -n "$target" ]
    return
  fi

  local key
  key="YEET_RUN_$(yeet_upper_key "$target")"

  if [ -n "${!key:-}" ]; then
    yeet_run_configured "$key" "run $target"
    return
  fi

  key="YEET_TEST_$(yeet_upper_key "$target")"
  yeet_run_configured "$key" "test $target"
}
