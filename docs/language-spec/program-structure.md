# Program Structure

## Overview

A Dois program is either made to be compiled into an executable, or imported in another program as a library.

## Main Procedure

The main procedure is the designated entry point of a Dois program. When a program is executed, the runtime system begins execution at the main procedure. This procedure must be named `main`.

Example:

```
proc main() do
  // program entry point code
end
```

## Libraries

Dois supports the inclusion of libraries to extend the functionality of programs. Libraries can provide additional procedures, types, and constants. To use a library, a module must declare it explicitly, allowing the compiler to resolve references to library elements.

Example:

```
import "Math"

proc calculate() {
  let result = Math.sqrt(25);
}
```

## Summary

Only one `main` procedure should exist when compiling.

Example:
```bash
doisc my_program.dois
```
... `my_program.dois` should only have a single `main` procedure defined; otherwise, the compilation will fail.
