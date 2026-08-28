#!/usr/bin/env bash

yeet_build_main() {
  local target="${1:-}"
  [ -n "$target" ] || yeet_die "Usage: yeet <project> build <target>"

  local key
  key="YEET_BUILD_$(yeet_upper_key "$target")"
  yeet_run_configured "$key" "build $target"
}
