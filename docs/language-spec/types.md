# Types

Types in **Dois** describe the shape of values and enable the compiler to verify program correctness.

Dois uses **static typing** with **Hindley–Milner style type inference**, meaning many types can be inferred automatically while still maintaining strong compile‑time guarantees.

The type system supports:

- primitive types
- parametric generics
- algebraic data types (ADTs)
- product types (records)
- union types (variants)

---

## Primitive Types

Primitive types are built-in value types provided by the language.

Common primitives include:

```dois
Int
Float
Bool
String
Char
Nil
```

Examples:

```dois
let a : Int     = 10;
let b : Float   = 3.14;
let c : Bool    = true;
let d : String  = "hello";
```

In many cases the compiler infers the type automatically.

```dois
let x = 42;        # inferred as Int
let y = "text";    # inferred as String
```

---

## Type Declarations

New types are declared using the `type` keyword.

```dois
type TypeName
    ...
end
```

Two major forms exist:

- **product types** (`has`)
- **union types** (`is`)

These correspond to the components of **algebraic data types (ADTs)**.

---

## Product Types

Product types define structures composed of multiple fields.

Syntax:

```dois
type Point has
  x : Int
  y : Int
end
```

Example construction:

```dois
let p = Point(x = 2, y = 3);
```

Fields are accessed using dot (`.`) notation.

```dois
p.x
p.y
```

Product types are similar to:

- structs (C, Rust)
- records (ML family)
- objects without behavior (OO)

---

## Union Types

Union types define a value that may be **one of several variants**.

Syntax:

```dois
type Maybe<T> is
  Some(T) | Nil
end
```

Example values:

```dois
let a = Some(value = 10);
let b = Nil;
```

Union types are commonly used for:

- optional values
- error handling
- tagged variants

---

# Generics

Types may be parameterized using **type variables**.

```dois
type Box<T> has
  value : T
end
```

Example:

```dois
let int_box : Box(Int) = Box(value = 10);

# Type inference still works
let str_box = Box(value = "hello");   
```

The compiler infers the type parameter automatically when possible.

---

## Pattern Matching With Types

Union types are typically consumed using `match`.

```dois
match maybe
  Some(v) => v
  Nil => 0
end
```

Pattern matching allows the compiler to ensure all variants are handled.

Example:

```dois
let x = Some(value = 4);

match x
  Some(value = v) => v
end
```
... will not compile, throwing an error for not handling the variant `Nil`

---

# Type Inference

Dois uses **Hindley–Milner style inference**, meaning explicit type annotations are often unnecessary.

Example:

```dois
let x = 10
let y = x + 5
```

The compiler infers:

```
x : Int
y : Int
```

Type annotations can still be provided for clarity.

```dois
let x : Int = 10
```

---

# Summary

The Dois type system includes:

- primitive types
- product types (`has`)
- union types (`is`)
- parametric generics
- algebraic data types
- Hindley–Milner type inference

These features allow expressive data modeling while maintaining strong compile‑time guarantees.
