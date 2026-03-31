// dois runtime support
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

typedef struct {
  bool is_ok;
  void* value;
  const char* error;
} DoisResult;

typedef struct {
  void** data;
  size_t length;
  size_t capacity;
} DoisArray;

typedef struct {
  void** keys;
  void** values;
  size_t length;
} DoisMap;

int64_t foo() {
return 5;
}
