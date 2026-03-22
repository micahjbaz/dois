
# Statements

Statements in Dois are the building blocks for writing imperative code. They perform actions such as assigning values, invoking procedures, and controlling program flow. They are the "do-" half that "Dois" is named after.

---

## Value Declarations

### Binding Declaration (`let`)

Use `let` to bind a value to an identifier.

```dois
let x = 10;
let name = "Alice";
```

### Variable Declaration (`var`)

Use `var` to declare an identifier as a variable value.

```dois
var counter = 0;
counter = counter + 1;

var uninitialized : Int; # Uninitialized variables are allowed, but not encouraged.
```

---

## Assignments

Assignment statements update the value of a variable.

```dois
var total = 42;
total = total + 8;
```

Assignment can and reassignment only be performed on variables declared with `var`.

```dois
let x = 2;
x = x + 1; # Error, cannot mutate bound identifier "x"
```

---

## Procedure Calls

Calling a procedure is a statement in Dois. Arguments are provided in parentheses.

```dois
print("Hello, world!");
increment(counter);
```

Procedure calls are inpure, and *must* be in a statement, not an expression.

---

## Control Flow Statements

Dois supports standard control flow constructs:

### If Statement

```dois
if x > 0 do
  print("Positive");
else if x < 0
  print("Non-positive");
else
  print("Zero");
end

```

The `else` block is optional.

### While Statement

```dois
var n = 5;
while n > 0 do
  print(n);
  n = n - 1;
end
```

### For Statement
<!-- TODO update to use iterators -->
```dois
for i in 0..10 do
  print(i);
end
```

---

## General Usage

Statements are written one per line, or separated by semicolons within a block. Braces `{ ... }` define statement blocks, and indentation is encouraged but not required.

```dois
let greeting = "Hi";
if greeting == "Hi" do
  print("Hello there!");
end
```

---

## Summary

- Use `let` for immutable variables, `var` for mutable ones.
- Assignment is only allowed for variables declared with `var`.
- Procedure calls, control flow (`if`, `while`, `for`) are all statements.
- Statements are separated by semicolons.
