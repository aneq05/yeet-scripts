#include "calculator.h"

#include <iostream>

int main() {
  std::cout << "2 + 3 = " << calculator::add(2, 3) << '\n';
  std::cout << "8 / 2 = " << calculator::divide(8, 2) << '\n';
  return 0;
}
