#!/usr/bin/env bash
set -euo pipefail

source scripts/common.sh

cxx="$(find_cxx)"
mkdir -p build

"$cxx" -std=c++17 -Wall -Wextra -Werror -Iinclude \
  tests/calculator_tests.cpp src/calculator.cpp \
  -o build/calculator_tests

build/calculator_tests
