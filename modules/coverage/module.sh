#!/usr/bin/env bash

yeet_coverage_main() {
  local target="${1:-ut}"
  if yeet_is_help_request "$target"; then
    cat <<'EOF'
Usage:
  yeet <project> coverage [target]

Examples:
  yeet my-app coverage
  yeet my-app coverage ut
EOF
    return
  fi

  local key

  key="YEET_COVERAGE_$(yeet_upper_key "$target")"
  if [ -n "${!key:-}" ]; then
    yeet_run_configured "$key" "coverage $target"
    return
  fi

  yeet_run_configured "YEET_COVERAGE" "coverage"
}
