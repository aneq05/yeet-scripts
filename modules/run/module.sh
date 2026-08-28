#!/usr/bin/env bash

yeet_run_main() {
  local target="${1:-}"
  [ -n "$target" ] || yeet_die "Usage: yeet <project> run <target>"

  local key
  key="YEET_RUN_$(yeet_upper_key "$target")"

  if [ -n "${!key:-}" ]; then
    yeet_run_configured "$key" "run $target"
    return
  fi

  key="YEET_TEST_$(yeet_upper_key "$target")"
  yeet_run_configured "$key" "test $target"
}
