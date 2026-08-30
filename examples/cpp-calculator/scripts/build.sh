#!/usr/bin/env bash
set -euo pipefail

source scripts/common.sh

cxx="$(find_cxx)"
mkdir -p build

"$cxx" -std=c++17 -Wall -Wextra -Werror -Iinclude \
  src/main.cpp src/calculator.cpp \
  -o build/calculator

printf 'Built build/calculator\n'
