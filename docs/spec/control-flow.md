# Control Flow

Control flow constructs allow either:
- Procedural branching for execution of statements in an impure context (`for` loop, `if` statement, etc)
- Expression branching for conditional evaluation in a pure context (`if` expression, `match` expression, etc)

---

## Conditional Branching (`if`)

Conditional branching allows executing code or evaluating to a branch when a given condition is true.

### Statement Form

```dois
if x > 0
  print("Positive");
elif x < 0
  print("Negative");
else
  print("Zero");
end
```

- `elif` and `else` are optional and the former can be repeated.


### Expression Form

Conditional expressions produce a value and can be used anywhere a value is expected.

```dois
let sign : Int =
  if x > 0
    1
  elif x < 0
    -1
  else
    0
  end
```

Unlike in a procedural context, the expression must satisfy:
- Each branch must evaluate to a type compatible with the others.
- The whole expression evaluates to the value of the matched branch.

---

## Loops
Loops are used to **repeat** a section of procedural code.

### `while` Loop

Repeatedly executes a block while a condition is true.

```dois
var n = 5;
while n > 0
  print(n);
  n = n - 1;
end
```

- The condition is checked *before* each iteration.

---

### `for` Loop

Iterates over a specified range of values.

```dois
for i : Int = 0; i < 10; do
  print(i);
end
```


---

## Pattern-Based Branching (`match`)

Pattern matching allows branching based on the structure of a value.

match maybe_value
  Some(value = v) => v,
  Nil             => 0
end

Notes:
- The entire `match` expression evaluates to the value produced by the matched branch.
- The compiler can enforce exhaustive handling of all variants.

---

## `return` and `raise`

In a procedure definition, early exit can be achieved with either:
- `return` to return an implicit `Ok`, or
- `raise` to return an implicit or explicit `Err` construct.

Example:
```dois
proc my_printer(x : Int) do
  if x == 0
    return;
  elif x < 0
    raise Err(message = "x cannot be less than 0", rc = 1);

  for i : Int = 0; i < x; do
    print(i);
  end
end
```

## Summary
- Use if statements for conditional actions; use if expressions to produce values.
- Use while and for loops for repeated execution.
- Use return to exit procedures early.
- Use match to branch based on value structure.
- Control flow constructs interact with the Dois type system and distinguish statement vs expression contexts.
