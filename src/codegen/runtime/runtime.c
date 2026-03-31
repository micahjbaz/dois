#include "runtime.h"

#include <stdlib.h>
#include <string.h>

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
  if (array->length >= array->capacity) {
    size_t new_capacity = array->capacity == 0 ? 4 : array->capacity * 2;
    array->data = (void**)realloc(array->data, sizeof(void*) * new_capacity);
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
  if (map->length >= map->capacity) {
    size_t new_capacity = map->capacity == 0 ? 4 : map->capacity * 2;
    map->keys = (void**)realloc(map->keys, sizeof(void*) * new_capacity);
    map->values = (void**)realloc(map->values, sizeof(void*) * new_capacity);
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