#!/usr/bin/env bash
set -euo pipefail

find_cxx() {
  if [ -n "${CXX:-}" ]; then
    printf '%s\n' "$CXX"
    return
  fi

  local compiler
  for compiler in c++ g++ clang++; do
    if command -v "$compiler" >/dev/null 2>&1; then
      printf '%s\n' "$compiler"
      return
    fi
  done

  printf 'No C++ compiler found. Install g++, clang++, or set CXX.\n' >&2
  exit 1
}
