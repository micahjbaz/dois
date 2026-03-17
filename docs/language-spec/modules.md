
# Modules
## Overview

**Modules** (or *libraries*)are the fundamental building blocks of a Dois program. Each module encapsulates related code and data. Modules can import other modules/libraries to use their functionality.

## Defining a Module

A module can be defined in either a `.dois` file that is compiled into an executable, or in a standalone file.

Example:
```dois
module MyModule has
  fn foo() : Int
    ...
  end

  proc do_something()
    ...
  end

  let pi = 3.14;
end
```

`MyModule` can be used like so:
```dois
proc main() do
  let x = MyModule::foo();

  MyModule::do_something();

  let radius = 5;
  let area = MyModule::pi * r * r;
end
```


## Importing Libraries:
Modules can be imported using the `import` keyword.

Example:

```
import MyModule

proc main() do
  MyModule::do_something();
end
```