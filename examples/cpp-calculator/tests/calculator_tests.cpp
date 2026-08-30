#include "calculator.h"

#include <cstdlib>
#include <iostream>
#include <stdexcept>

namespace {

void expect_eq(int actual, int expected, const char* name) {
  if (actual != expected) {
    std::cerr << name << ": expected " << expected << ", got " << actual << '\n';
    std::exit(1);
  }
}

void expect_division_by_zero() {
  try {
    (void)calculator::divide(1, 0);
  } catch (const std::invalid_argument&) {
    return;
  }

  std::cerr << "divide_by_zero: expected std::invalid_argument\n";
  std::exit(1);
}

}  // namespace

int main() {
  expect_eq(calculator::add(2, 3), 5, "add");
  expect_eq(calculator::subtract(7, 4), 3, "subtract");
  expect_eq(calculator::multiply(6, 5), 30, "multiply");
  expect_eq(calculator::divide(8, 2), 4, "divide");
  expect_division_by_zero();

  std::cout << "Unit tests passed\n";
  return 0;
}
