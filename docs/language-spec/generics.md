

# Generics

Generics allow types and functions in **Dois** to operate over a range of types while preserving type safety.

Instead of writing separate implementations for each type, a generic definition can work with **type parameters** that are determined by the compiler during type inference.

Dois supports **parametric polymorphism**, similar to languages in the ML and Rust families.

---

##  Generic Type Parameters

Generic parameters are declared using angle brackets after the type, function, or procedure name.

```
<T>
<K, V>
<T, E>
```

Example:

```dois
type Box<T> has
  value : T
end
```

This represents a `Box` that can contain *any* type.

---

## Constructing Generic Values

Generic parameters are usually inferred automatically.

```dois
let int_box = Box(value = 10);
let str_box = Box(value = "hello");
```

The compiler infers:

```
int_box : Box<Int>
str_box : Box<String>
```

Explicit type parameters are rarely required.

---

## Generic Union Types

Generics are commonly used with **union types** to represent flexible data structures.

Example:

```dois
type Maybe<T> is
  Some(T) | Nil
end
```

Usage:

```dois
let a = Some(10);
let b = Nil;
```

The compiler infers:

```
a : Maybe<Int>
b : Maybe<Int>
```

---

## Generic Functions

Functions may also accept type parameters.

```dois
fn identity<T>(value: T) : T
    value
end
```

Example usage:

```dois
let a = identity$(10)
let b = identity$("hello")
```

Type inference determines the concrete type of `T` automatically.

---

## Multiple Type Parameters

Definitions may include multiple type parameters.

```dois
type Pair<A, B> has
    first  : A
    second : B
end
```

Example:

```dois
let pair = Pair(first = 1, second = "hello")
```

The inferred type:

```
Pair<Int, String>
```

---

## Type Inference With Generics

Dois uses **Hindley–Milner style inference**, meaning generic types are usually deduced without explicit annotations.

Example:

```dois
fn first<A, B>(pair: Pair<A, B>) : A
  pair.first
end
```

Usage:

```dois
let p = Pair(first = 10, second = "hello");
let x = first$(p);
```

The compiler infers:

```
x : Int
```

---

## Summary

Generics in Dois provide:

- parametric polymorphism
- reusable type definitions
- reusable function definitions
- strong compile-time type safety
- integration with Hindley–Milner inference

Generics are widely used when defining data structures such as `Maybe`, `Result`, `Pair`, and other reusable abstractions.