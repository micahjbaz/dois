# Functions

Functions in **Dois** are expressions that can be called, or *evaluated*.

## Defining a Function

```dois
fn function_name<T, ...>(param1: Type1, param2: Type2, ...) : ReturnType
  # expression body  
end
```
<!-- TODO get rid of => and $ needed for fn declaration in lang-->

### Examples

```dois
fn add(x: Int, y: Int) : Int
  x + y
end

fn identity<T>(value: T) : T
  value
end

fn square(x: Int) : Int
  x * x
end
```

## Return Type Inference

Parameters and return types can sometimes be inferred if not explicitly provided, but explicit types improve readability and error reporting.

```dois
fn double(x: Int)
  x * 2  // inferred return type is Int
end
```

## Generics

Functions can accept optional generic parameters to operate on multiple types.

```dois
fn swap$<T>(a: T, b: T) : (T, T)
  (b, a)
end
```
<!-- TODO have to add tuple typing -->

## Calling Functions

Functions are called, or *evaluated* using the `$` operator.

```dois
let sum = add$(1, 2);
let self = identity$(12);
let swapped = swap$(("first", "second"));
```