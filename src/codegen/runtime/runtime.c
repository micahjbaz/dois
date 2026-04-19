#include "runtime.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void dois_runtime_fatal(const char* message) {
  fprintf(stderr, "dois runtime error: %s\n", message);
  abort();
}

void dois_runtime_init(void) {
  // no-op for now
}

void dois_runtime_shutdown(void) {
  // no-op for now
}

DoisArray dois_array_new(void) {
  DoisArray array;
  array.data = NULL;
  array.length = 0;
  array.capacity = 0;
  return array;
}

void dois_array_push(DoisArray* array, void* value) {
  if (array == NULL) {
    dois_runtime_fatal("dois_array_push called with NULL array");
  }

  if (array->length >= array->capacity) {
    size_t new_capacity = array->capacity == 0 ? 4 : array->capacity * 2;
    void** new_data = (void**)realloc(array->data, sizeof(void*) * new_capacity);

    if (new_data == NULL) {
      dois_runtime_fatal("failed to grow DoisArray");
    }

    array->data = new_data;
    array->capacity = new_capacity;
  }

  array->data[array->length++] = value;
}

DoisMap dois_map_new(void) {
  DoisMap map;
  map.keys = NULL;
  map.values = NULL;
  map.length = 0;
  map.capacity = 0;
  return map;
}

void dois_map_put(DoisMap* map, void* key, void* value) {
  if (map == NULL) {
    dois_runtime_fatal("dois_map_put called with NULL map");
  }

  if (map->length >= map->capacity) {
    size_t new_capacity = map->capacity == 0 ? 4 : map->capacity * 2;
    void** new_keys = (void**)realloc(map->keys, sizeof(void*) * new_capacity);
    void** new_values = (void**)realloc(map->values, sizeof(void*) * new_capacity);

    if (new_keys == NULL || new_values == NULL) {
      free(new_keys);
      free(new_values);
      dois_runtime_fatal("failed to grow DoisMap");
    }

    map->keys = new_keys;
    map->values = new_values;
    map->capacity = new_capacity;
  }

  map->keys[map->length] = key;
  map->values[map->length] = value;
  map->length += 1;
}

DoisResult dois_ok(void* value) {
  DoisResult result;
  result.is_ok = true;
  result.value = value;
  result.error = NULL;
  return result;
}

DoisResult dois_err(const char* error) {
  DoisResult result;
  result.is_ok = false;
  result.value = NULL;
  result.error = error;
  return result;
}

void dois_print_int(int64_t value) {
  printf("%" PRId64 "\n", value);
}

void dois_print_float(double value) {
  printf("%f\n", value);
}

void dois_print_bool(bool value) {
  printf("%s\n", value ? "true" : "false");
}

void dois_print_string(const char* value) {
  if (value == NULL) {
    printf("nil\n");
  } else {
    printf("%s\n", value);
  }
}