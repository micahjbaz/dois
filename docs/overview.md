# Dois Language Overview

Dois is a statically typed programming language designed around a clear separation between **expressions** and **statements**, and between **functions** and **procedures**. This separation allows the language to support both **functional** and **procedural** programming styles in a consistent way.

The guiding idea of Dois is that some constructs exist to **compute values**, while others exist to **perform actions**. Making this distinction explicit simplifies reasoning about code, side effects, and program structure.

---

## Statements vs Expressions

In Dois, we make a clear distinction between **statements** (things that *do*) and **expressions** (things that *are*).

### Statements

Statements perform actions and may produce side effects. They do not inherently produce a value.

Examples of statements include:

- `let` bindings
- `var` assignments
- `proc` (procedure) calls
- loops (`while`, `for`)
- control-flow blocks inside procedures

Example:

```dois
var x : Int = 10;
x = x + 1;
println(x);
```

Each line performs an action rather than evaluating to a value.

### Expressions

Expressions evaluate to a value and can be used anywhere a value is expected.

Examples include:

- arithmetic operations
- function calls
- conditional expressions
- pattern matching expressions

Example:

```dois
let x = 10 + 2 * 3;
```

The expression `10 + 2 * 3` evaluates to the value `16`.

Expressions are the building blocks of **function bodies** and other value-producing constructs.

---

## Procedures vs Functions

Dois separates **functions** from **procedures**.

This distinction enforces a clear boundary between **pure computation** and **side effects**.

### Functions

Functions:

- are **pure** (no side effects)
- consist of a **single expression**
- *always* return a value
- are called using the `$` applicator

Example:

```dois
fn add (a : Int, b : Int) : Int 
  a + b
end

let result = add$(2, 3);
```

Because functions are pure, they are easy to reason about and compose.

### Procedures

Procedures:

- may perform **side effects**
- consist of **statements** inside a `do ... end` block

Example:

```dois
proc greet(name : String) do
  println("Hello, ");
  println(name);
end
```

Procedures are typically used for:

- input/output
- mutation
- control flow
- interacting with the outside world

---

## Type System Overview

Dois uses a **statically typed system with type inference**.

This means:

- Every value has a type
- Types are checked at compile time
- Explicit annotations are optional when the compiler can infer them

Example:

```dois
let x = 10;      # inferred as Int
let y = "hello"; # inferred as String
```

The type system supports:

- primitive types (`Int`, `Float`, `Bool`, etc.)
- product types (records / structs)
- union types
- generic types
- parametric polymorphism

Type inference is based on a Hindley–Milner style system extended with structural typing and generics.

---

## Compilation Model

Dois is compiled using a **transpilation pipeline**.

The compilation process is:

1. Parse `.dois` source files into an abstract syntax tree (AST)
2. Perform type checking and type inference
3. Generate equivalent **C code**
4. Compile the generated C code into machine code using a system C compiler

Memory management is handled using the **Boehm–Demers–Weiser garbage collector**, allowing programs to allocate freely without manual memory management.

This model provides:

- portability
- predictable performance
- easy integration with C tooling

---

## Design Philosophy

The design of Dois emphasizes:

- **clarity** — explicit distinction between pure and impure code
- **type safety** — strong static typing with inference
- **composability** — small expressions forming larger computations
- **simplicity of implementation** — a compiler architecture that remains approachable

By separating computation from side effects and keeping the type system expressive but tractable, Dois aims to provide a language that reinforces *good programming practices*.
