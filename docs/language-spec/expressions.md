

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
let y = square$(x);
```

---

## Arithmetic Expressions

Dois supports standard arithmetic operators.

```dois
+     # addition
-     # subtraction
*     # multiplication
/     # integer division
//    # float division
%     # modulus
```

Example:

```dois
let a = 5 + 3;    # 8
let b = 10 - 4;   # 6
let c = 6 * 7;    # 42
let d = 20 / 3;   # 6
let e = 20 // 3;  # 6.66...
let f = 9 % 4;    # 1
```

Operator precedence follows typical mathematical rules:

```
1. *, 
2. /
3. %
4. +
5. -
```
1. `*`, `/`, `//`
2. `%`
3. `+`, `-`

Parentheses can be used to override precedence.

```dois
let result = (2 + 3) * 4; # 20
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

## Function/Procedure Call Expressions

A call to eithe a function or procedure is an expression

```dois
let f_res = my_function$(arg1, arg2);
let p_res = my_procedure();
```


Arguments themselves may be expressions.

```dois
let r = add$(2 + 3, 4 * foo$(6));
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


## References

Reference operations are expressions that interact with mutable storage.

### Read Expression

```
@x
```

- Evaluates to the value stored inside a reference `x`
- If `x : Ref<T>`, then `@x : T`

Example:

```
var r = ref(10);
let v = @r;  # 10
```

### Write Expression

```
x := value
```

- Updates the value stored in reference `x`
- `x` must be of type `Ref<T>`
- `value` must be of type `T`
- Mutation via `:=` is only allowed in procedural contexts (see Procedures)

Example:

```
var r = ref(10);
r := 20;
```

### Notes

- References represent mutable storage locations
- `@x` and `x := v` are expressions in the language syntax, but mutation semantics are restricted by context
- See [References](../runtime/references.md) for the full specification of references and mutability rules


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