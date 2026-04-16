

# Procedures

Procedures represent **impure operations** in Dois.  
They are typically used for tasks that involve side effects such as:

- input/output
- mutation
- interacting with the environment
- calling external systems

Procedures differ from functions in that they **do not return arbitrary values**.

---

# Syntax

Procedures are declared using the `proc` keyword.

```dois
proc procedure_name(param1: Type1, param2: Type2)
  <statements>
end
```

Example:

```dois
proc print_point(p: Point<Int>)
  println("x: " + p.x + ", y: " + p.y);
end
```

Procedures may contain statements such as variable declarations, assignments, control flow, and other procedure calls.

---

## The `Result` Type

Every procedure in Dois implicitly returns a value of type `Result`, where:

```dois
type Result is Ok | Err end

type Ok end     # Ok has no fields

type Err has
  message : String,
  rc : Int
end
```

This return type does **not need to be written** in the procedure declaration.

The returned `Result` indicates whether the procedure executed successfully or encountered an error.

Example:

```dois
proc log_message(msg: String)
  println(msg);
end
```

Even though no value is explicitly returned, the procedure implicitely returns `Ok()`

---

## Raising Errors

A procedure may explicitly return an error value.

```dois
proc write_file(path: String, contents: String)
  let res = write_to_file();
  if res != Ok() do
    raise Err(message = "write failed", rc = 1);
  end
end
```

Raising an error stops execution of the procedure and produces an `Err` result.

---

## Calling Procedures

Procedures are invoked as **statements**.

```dois
print_point(p);
log_message("hello");
```

The implicit `Result` may be ignored or inspected.

Example:

```dois
let r = write_file("output.txt", "hello");

if r != Ok() do
  println("Failure!");
end
```

## Error Propagation

To prevent unnecessary boilerplate when inspecting the result of a `proc` call, the `?` propagation operator can be used to implicitly propagate the error through the current procedure.

Example:

```dois
proc always_fails() do
  raise Err(
    message = "always_fails() always fails", 
    rc = 1
  );
end

always_fails()?

# Desugars to:
#   let res = always_fails();
#   if res != Ok() do
#     raise res;
#   end
#   # otherwise continue...

```
---

## Procedures vs Functions



---

##  Summary

Procedures:

- perform side effects
- contain a list statements
- implicitly return a `Result`
- may explicitly raise an error
- may not be called in pure (`fn`) code bodies