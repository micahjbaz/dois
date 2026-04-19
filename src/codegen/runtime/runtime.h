

#ifndef DOIS_RUNTIME_H
#define DOIS_RUNTIME_H

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include <inttypes.h>

#ifdef __cplusplus
extern "C" {
#endif

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
  size_t capacity;
} DoisMap;

void dois_runtime_init(void);
void dois_runtime_shutdown(void);

DoisArray dois_array_new(void);
void dois_array_push(DoisArray* array, void* value);

DoisMap dois_map_new(void);
void dois_map_put(DoisMap* map, void* key, void* value);


DoisResult dois_ok(void* value);
DoisResult dois_err(const char* error);

void dois_print_int(int64_t value);
void dois_print_float(double value);
void dois_print_bool(bool value);
void dois_print_string(const char* value);

#ifdef __cplusplus
}
#endif

#endif