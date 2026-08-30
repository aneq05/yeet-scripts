#!/usr/bin/env bash
set -euo pipefail

source scripts/common.sh

cxx="$(find_cxx)"
gcov_tool="${GCOV:-gcov}"

if ! command -v "$gcov_tool" >/dev/null 2>&1; then
  printf 'No gcov found. Install gcov or set GCOV.\n' >&2
  exit 1
fi

minimum_coverage="${YEET_COVERAGE_MIN:-90}"
if ! awk -v value="$minimum_coverage" \
  'BEGIN { exit !(value ~ /^[0-9]+([.][0-9]+)?$/ && value >= 0 && value <= 100) }'; then
  printf 'YEET_COVERAGE_MIN must be a number between 0 and 100.\n' >&2
  exit 1
fi

rm -rf build/coverage coverage
mkdir -p build/coverage coverage
rm -f ./*.gcda ./*.gcno ./*.gcov

"$cxx" --coverage -O0 -g -std=c++17 -Iinclude \
  tests/calculator_tests.cpp src/calculator.cpp \
  -o build/coverage/calculator_tests

build/coverage/calculator_tests >/dev/null

gcov_output="$("$gcov_tool" -o . src/calculator.cpp)"
printf '%s\n' "$gcov_output" > coverage/summary.txt
if [ -f calculator.cpp.gcov ]; then
  mv calculator.cpp.gcov coverage/calculator.cpp.gcov
fi
rm -f ./*.gcda ./*.gcno ./*.gcov

actual_coverage="$(printf '%s\n' "$gcov_output" \
  | sed -n 's/^Lines executed:\([0-9.]*\)%.*/\1/p' \
  | head -n 1)"
if [ -z "$actual_coverage" ]; then
  printf 'Could not read line coverage from gcov output.\n' >&2
  exit 1
fi

if ! awk -v actual="$actual_coverage" -v minimum="$minimum_coverage" \
  'BEGIN { exit !(actual + 0.0 >= minimum + 0.0) }'; then
  printf 'Line coverage %.2f%% is below the %.2f%% minimum.\n' \
    "$actual_coverage" "$minimum_coverage" >&2
  exit 1
fi

printf 'Line coverage: %.2f%% (minimum: %.2f%%)\n' \
  "$actual_coverage" "$minimum_coverage"
printf 'Coverage summary written to coverage/summary.txt\n'
