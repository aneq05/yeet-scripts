#!/usr/bin/env bash
set -euo pipefail

source scripts/common.sh

cxx="$(find_cxx)"
gcov_tool="${GCOV:-gcov}"

if ! command -v "$gcov_tool" >/dev/null 2>&1; then
  printf 'No gcov found. Install gcov or set GCOV.\n' >&2
  exit 1
fi

rm -rf build/coverage coverage
mkdir -p build/coverage coverage
rm -f ./*.gcda ./*.gcno ./*.gcov

"$cxx" --coverage -O0 -g -std=c++17 -Iinclude \
  tests/calculator_tests.cpp src/calculator.cpp \
  -o build/coverage/calculator_tests

build/coverage/calculator_tests >/dev/null

"$gcov_tool" -o . src/calculator.cpp > coverage/summary.txt
if [ -f calculator.cpp.gcov ]; then
  mv calculator.cpp.gcov coverage/calculator.cpp.gcov
fi
rm -f ./*.gcda ./*.gcno ./*.gcov
printf 'Coverage summary written to coverage/summary.txt\n'
