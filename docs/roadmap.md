

# Roadmap

This document tracks the likely development direction for Dois from its current compiler state toward a more complete language implementation.

It is not a strict commitment. It is a planning document for sequencing work and keeping the project guided.

---

## Current Status

Dois currently has a working end-to-end pipeline:

```text
.dois source file
  → parse
  → type check / semantic verification
  → generate C
  → compile with `cc`
  → run native executable
```

Working pieces now include:

- module-based source structure
- AST with semantic annotations
- parser and verifier for core language forms
- codegen split across declarations, functions, expressions, and types
- shared C runtime
- builtin `print`
- working arithmetic, bindings, function calls, constructor lowering, and observable execution

---

## Guiding Priorities

Near-term work should favor:

1. **correctness over feature count**
2. **clean stage separation over quick hacks**
3. **observable end-to-end behavior over abstract internal progress**
4. **language clarity over premature complexity**


---

## Short-Term Roadmap

These are the most important next milestones from the current state of the compiler.

### 1. Tighten Semantic Resolution

Goal: make symbol resolution more semantically correct and less approximate.

Current issue:
- some identifier handling still relies on current module context rather than true resolved declaration identity

Work:
- make identifier resolution consistently point to actual declarations
- reduce remaining builtin special-casing where possible
- improve symbol identity handling across declarations and references

---

### 2. Improve Codegen Correctness

Goal: make generated C more faithful to the source language.

Work:
- fix union payload typing and layout
- improve struct/product initialization handling
- expand expression lowering coverage
- improve statement lowering coverage
- ensure generated types map correctly for all supported source forms


---

### 3. Expand Observable Runtime Behavior

Goal: increase the number of language programs that visibly run correctly.

Work:
- extend builtin print coverage where appropriate
- add more runtime helpers as needed
- make examples more expressive and testable

---

### 4. Strengthen End-to-End Testing

Goal: shift from mostly parser/typechecker confidence to actual compiler confidence.

Work:
- add end-to-end examples that compile and run
- keep known-good examples under `examples/`
- add checks around generated C output where useful
- add tests for codegen regressions

---

## Mid-Term Roadmap


### 1. Better Control Flow Coverage

Work:
- improve `if` lowering and validation
- improve loop support
- expand boolean/comparison operator support
- make pattern matching more complete

---

### 2. Pattern Matching / Exhaustiveness

Work:
- improve union matching support
- add exhaustiveness checking
- improve match lowering in codegen


---

### 3. Imports / Multi-Module Programs

Work:
- define import syntax and semantics
- resolve cross-module names properly
- decide how files/modules map to compilation units
- improve symbol resolution accordingly


---

### 4. Better Builtin / Prelude Design

Work:
- implement clearer prelude model
- decide which builtins are language-level vs runtime-level vs standard-library-level
- reduce ad hoc builtin handling in verifier/codegen

---

## Long-Term Roadmap


### 1. Standard Library

Potential areas:
- collections
- iterators
- IO
- string utilities
- result/error helpers


---

### 2. Runtime / Memory Model

Potential work:
- better data representation decisions
- array/map ownership strategy
- memory management policy
- more realistic runtime support for language values


---

### 3. Optimization / IR Improvements

Potential work:
- introduce a more explicit lowered IR before C emission
- optimize generated output
- improve code quality and performance

---

### 4. Tooling / Developer Experience

Potential work:
- better CLI flags
- clearer diagnostics
- source-to-generated-code debugging support
- project-level commands beyond current `make` workflow

---

## Architecture Goals

As the compiler grows, these architectural goals should remain stable.

### 1. Semantic results should live on the AST

Codegen should consume semantic annotations like:
- `resolved_type`
- `symbol_ref`

It should not depend on active verifier state.

### 2. Codegen should remain staged and specialized

Keep responsibility split across:
- type codegen
- expression codegen
- function/procedure codegen
- declaration codegen
- top-level transpiler orchestration

### 3. Runtime should remain explicit

Generated C should target a known runtime ABI rather than smuggling runtime behavior implicitly into generated code.

### 4. New features should preserve language clarity

Dois is not just a compiler project. It is also a language design project.

That means features should be added in a way that supports the language’s identity rather than just increasing raw feature count.

