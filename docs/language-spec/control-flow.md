# Control Flow

Control flow constructs determine the order in which statements and expressions are executed. Dois provides mechanisms for conditional branching, loops, early returns, and pattern-based branching.

---

## Conditional Branching (`if`)

Conditional branching allows executing code only when a condition is true.

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

Notes:
- elif is optional and can be repeated.
- else is optional.
- This form is a statement: used for side effects.


### Expression Form

Conditional expressions produce a value and can be used anywhere a value is expected.

let sign : Int =
  if x > 0
    1
  elif x < 0
    -1
  else
    0
  end

Rules:
- Each branch must evaluate to a type compatible with the others.
- The whole if expression evaluates to the value of the matched branch.

---

## Loops

### `while` Loop

Repeatedly executes a block while a condition is true.

```dois
var n = 5;
while n > 0
  print(n);
  n = n - 1;
end
```

- The condition is checked before each iteration.
- Loops are statements, not expressions.

---

### `for` Loop

Iterates over a specified range of values.

```dois
for i : Int = 0; i < 10; do
  print(i);
end
```


---

## Pattern-Based Branching (match)

Pattern matching allows branching based on the structure of a value.

match maybe_value
  Some(value = v) => v
  Nil             => 0
end

Notes:
	•	match evaluates to the value produced by the matched branch if used as an expression.
	•	The compiler can enforce exhaustive handling of all variants.

---

## Summary
- Use if statements for conditional actions; use if expressions to produce values.
- Use while and for loops for repeated execution.
- Use return to exit functions or procedures early.
- Use match to branch based on value structure.
- Control flow constructs interact with the Dois type system and distinguish statement vs expression contexts.

---