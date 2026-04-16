# Lexical Structure

This section defines the basic textual elements of **Dois**: comments, identifiers, keywords, and literals.

---

##  Comments

Comments are ignored by the compiler and are used to document code.

Dois supports **single-line comments** using the `#` character.

Everything following `#` on the same line is treated as a comment.

Example:

```dois
# This is a comment
let x = 10;  # This is also a comment
```

---

##  Identifiers

Identifiers are names used for variables, functions, procedures, types, and other user-defined symbols.

Identifiers must follow these rules:

- They must begin with a letter (`a-z`, `A-Z`) or underscore (`_`).
- They may contain letters, digits, and underscores.
- They must not be a reserved keyword.

Examples of valid identifiers:

```dois
x
count
_point
value2
```

Examples of invalid identifiers:

```dois
2value
let
fn
```

---

##  Keywords

Keywords are reserved words in the language that have special meaning and cannot be used as identifiers.

Common Dois keywords include:

```
fn
proc
let
if
else
match
while
for
do
return
raise
end
```

Additional keywords may be introduced as the language evolves.
<!-- TODO add all keywords -->
---

##  Literals

Literals are fixed values written directly in source code.

Common literal forms include:

### Integer literals

```dois
0
42
-7
```

### Boolean literals

```dois
true
false
```

### Character literals

Characters are enclosed in single quotes.

```dois
'c'
'h'
```

### String literals

Strings are enclosed in double quotes.

```dois
"hello"
"dois"
```

Additional literal types may be added in future versions of the language.