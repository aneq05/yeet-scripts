#!/usr/bin/env bash

yeet_build_main() {
  local target="${1:-}"
  if yeet_is_help_request "$target" || [ -z "$target" ]; then
    cat <<'EOF'
Usage:
  yeet <project> build <target>

Example:
  yeet my-app build app
EOF
    [ -n "$target" ]
    return
  fi

  local key
  key="YEET_BUILD_$(yeet_upper_key "$target")"
  yeet_run_configured "$key" "build $target"
}
