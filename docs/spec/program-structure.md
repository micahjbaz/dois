# Program Structure

A **Dois** file is either made to be compiled into an executable, or imported in another program as a library.

## Main Procedure

The `main` procedure is the designated entry point of a Dois program.

```
proc main() do
  // program procedure
end
```

Only one `main` procedure should exist when compiling.

## Importing Libraries

Libraries can provide additional procedures, types, and constants. To use a library, a module must declare it explicitly, allowing the compiler to resolve references to library elements.

Example:

```
import "Math"

proc calculate() {
  let result = Math.sqrt(25);
}
```
---