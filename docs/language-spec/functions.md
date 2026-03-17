# Functions

Functions in **Dois** are expressions that can be called, or *evaluated*.

## Syntax

```dois
fn function_name<T>(param1: Type1, param2: Type2, ...) : ReturnType
  <expression>
end
```
<!-- TODO get rid of => and $ needed for fn declaration-->

- `fn` – keyword to declare a function.
- `<T>` – optional generic type parameters.
- `param: Type` – parameters with their types annotated.
- `: ReturnType` – annotates the type of value the function evaluates to.
- `<expression>` – the expression to be evaluated.

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

## Type Inference

Parameters and return types can sometimes be inferred if not explicitly provided, but explicit types improve readability and error reporting.

```dois
fn double(x: Int)
  x * 2  // inferred return type is Int
end
```

## Generics

Functions can accept generic parameters to operate on multiple types.

```dois
fn swap$<T>(a: T, b: T) : (T, T)
  (b, a)
end
```
<!-- TODO have to add tuple typing -->

## Best Practices

- Use descriptive names for both the function and parameters.
- Prefer explicit type annotations for public APIs.