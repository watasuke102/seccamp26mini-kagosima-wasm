#include <cstdint>
#include <print>

int32_t add(int32_t lhs, int32_t rhs) {
  return lhs + rhs;
}

int main() {
  std::println("{}", add(1, 2));
}
