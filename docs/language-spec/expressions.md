

# Expressions

Expressions in **Dois** represent computations that produce a value.  
Unlike statements, which perform actions, expressions always evaluate to a result.

Expressions are the primary building blocks of **functions**, **value bindings**, and many control-flow constructs. They are the *-is* half that "Dois" is named after.

---

##  Expression Basics

An expression evaluates to a value.

Examples:

```dois
10
"hello"
true
x + y
square$ (5)
```

Expressions can appear anywhere a value is expected.

```dois
let x = 10 + 2 * 3;
let y = square$ (x);
```

---

## Arithmetic Expressions

Dois supports standard arithmetic operators.

```dois
+     # addition
-     # subtraction
*     # multiplication
/     # division
%     # modulus
```

Example:

```dois
let a = 5 + 3;    # 8
let b = 10 - 4;   # 6
let c = 6 * 7;    # 42
let d = 20 / 5;   # 4
let e = 9 % 4;    # 1
```

Operator precedence follows typical mathematical rules:

```
1. *
2. /
3. %
4. +
5. -
```

Parentheses can be used to override precedence.

```dois
let result = (2 + 3) * 4;
```

---

## Boolean Expressions

Boolean expressions evaluate to `true` or `false`.

Comparison operators:

```dois
==
!=
<
<=
>
>=
```

Logical operators:

```dois
&&    # Logical 'and'
||    # Logical 'or'
!     # Logical 'not'
```

Example:

```dois
let a = x > 10;
let b = y == 0;
let c = a && b;
let d = !c;
```

---

## Function Call Expressions

Functions are evaluated using the `$` applicator.

```dois
function_name$(arg1, arg2)
```

Example:

```dois
fn add(x: Int, y: Int) : Int
    x + y
end

let result = add$(2, 3);
```

Arguments themselves may be expressions.

```dois
let r = add$(2 + 3, 4 * 5);
```

---

## Field Access Expressions

Fields of product types are accessed using dot (`.`) notation.

```dois
value.field
```

Example:

```dois
type Point has
  x : Int
  y : Int
end

let p = Point(x = 2, y = 3);
let px = p.x;
let py = p.y;
```

---

## Constructor Expressions

Values of product or union types can be constructed using constructor syntax.

Example:

```dois
type Point has
  x : Int
  y : Int
end

let p = Point(x = 2, y = 3);
```


---

## Conditional Expressions

The `if` construct may be used as an expression.

```dois
if condition
  expr1
elif other_condition
  expr2
else
  expr3
end
```

Example:

```dois
let result : Int =
  if   x > 0 =>  1
  elif x < 0 => -1
  else       =>  0
  end
```

Each branch must evaluate to a compatible type.

---

## Match Expressions

Pattern matching allows branching based on value structure.

```dois
match value
    Pattern1 => expr1
    Pattern2 => expr2
end
```

Example:

```dois
match maybe_value
    Some(value = v) => v,
    Nil             => 0
end
```

Match expressions evaluate to the value produced by the matched branch.


---

# Summary

Expressions in Dois include:

- literals
- arithmetic operations
- boolean logic
- function calls
- proc calls (see [Procedures](./procedures.md) for more info)
- field access
- type constructor expressions
- conditional (`if`) expressions
- `match` expressions

Every expression evaluates to a value, making expressions the foundation of computation in the language.