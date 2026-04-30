# Architecture

This document describes the current compiler architecture for Dois, the major stages in the compilation pipeline, and the main responsibilities of each subsystem.

It is meant as a *working internal reference*, not a formal language spec. For the language specification, see the [language spec](./spec/README.md).

---

## High-Level Pipeline

The current compiler pipeline is:

```text
.dois source file
  → lexer
  → parser
  → AST
  → semantic analysis / type checking
  → annotated AST
  → C code generation
  → C runtime
  → native executable (via `cc`)
```

At a high level:

- **lexing** turns source text into tokens
- **parsing** builds syntax structures
- **semantic analysis / type checking** verifies correctness and annotates AST nodes
- **code generation** lowers the annotated AST into C
- **runtime** provides shared C support functions

---

## Lexical Analysis / Lexing

### Responsibility

The `Lexer` turns raw source text into a stream of tokens.

### Key file(s)

- [`src/parsing/lexer.cr`](../src/parsing/lexer.cr#L8), `DoisC::Parsing::Lexer`

### Output

The lexer produces token values defined in:

- [`src/ast_data/token.cr`](../src/ast_data/token.cr#L9), `DoisC::ASTData::Token`

### Notes

The lexer is responsible only for tokenization. It does not attempt to resolve names, assign types, or interpret semantic meaning.

---

## Syntax Analysis / Parsing

### Responsibility

The parser consumes tokens and builds the source abstract syntax tree (AST).

### Key files

- [`src/parsing/parser.cr`](../src/parsing/parser.cr#L17), `DoisC::Parsing::Parser`
- [`src/parsing/declaration_parser.cr`](../src/parsing/declaration_parser.cr#L6), `DoisC::Parsing::DeclarationParser`
- [`src/parsing/expression_parser.cr`](../src/parsing/expression_parser.cr#L7), `DoisC::Parsing::ExpressionParser`
- [`src/parsing/literal_parser.cr`](../src/parsing/literal_parser.cr#L7), `DoisC::Parsing::LiteralParser`
- [`src/parsing/pattern_parser.cr`](../src/parsing/pattern_parser.cr#L6), `DoisC::Parsing::PatternParser`
- [`src/parsing/procedure_parser.cr`](../src/parsing/procedure_parser.cr#L8), `DoisC::Parsing::ProcedureParser`

### Current model

A file currently parses as a single root module declaration.

Conceptually:

```text
file
  → module declaration
    → declarations / statements
```

### Notes

The parser is responsible for syntax only. It does not resolve names or assign types.

---

## Abstract Syntax Tree (AST)

### Responsibility

The AST is the shared data model passed between compiler stages.

### Key files

- [`src/ast_data/ast.cr`](../src/ast_data/ast.cr#L8), `DoisC::ASTData::*`
- [`src/ast_data/source_location.cr`](../src/ast_data/source_location.cr#L3), `DoisC::ASTData::SourceLocation`
- [`src/ast_data/symbol_ref.cr`](../src/ast_data/symbol_ref.cr#L9), `DoisC::ASTData::SymbolRef`

### Role of the AST

The AST stores:

- syntax structure
- source locations
- semantic annotations added during later stages

### Current semantic annotations on AST nodes

Some AST nodes are currently annotated during semantic analysis with:

- `resolved_type`
  - the semantic type determined for an expression or declaration
- `symbol_ref`
  - the resolved symbolic identity of a declaration or identifier reference


---

## Semantic Analysis / Type Checking

### Responsibility

Semantic analysis currently happens in three stages:

- **registration** — registers references for declared types
- **resolution** — resolves each declared type reference to a definition
- **verification** — verifies that typed program usage is valid

State is maintained in two environment structures across these stages:

- **global environment** — stores type references, type definitions, and builtins
- **verification context** — stores local traversal state while the verifier checks the program


### Key files

- [`src/type_checking/checker.cr`](../src/type_checking/checker.cr#L18), 
  `DoisC::TypeChecking::TypeChecker`
  - [`src/type_checking/registrar.cr`](../src/type_checking/registrar.cr#L11),
  `DoisC::TypeChecking::Registrar`
  - [`src/type_checking/resolver.cr`](../src/type_checking/resolver.cr#L12),
  `DoisC::TypeChecking::Resolver`
  - [`src/type_checking/verifier.cr`](../src/type_checking/verifier.cr#L21),
  `DoisC::TypeChecking::Verifier`
    - [`src/type_checking/type_engine.cr`](../src/type_checking/type_engine.cr#L12),
  `DoisC::TypeChecking::TypeEngine`


- [`src/type_checking/type_error.cr`](../src/type_checking/type_error.cr),
  `DoisC::TypeChecking::TypeError`, etc.
- [`src/type_checking/error_reporter.cr`](../src/type_checking/error_reporter.cr#L6),
  `DoisC::TypeChecking::ErrorReporter`

### Supporting Environment

- [`src/environment/global.cr`](../src/environment/global.cr#L8)
  `DoisC::Environment::Global`
- [`src/environment/verification_context.cr`](../src/environment/verification_context.cr#L8),
  `DoisC::Environment::VerificationContext`

### Main responsibilities

The verifier currently handles most semantic work, including:

- validating declarations
- checking expression types
- checking statement validity
- verifying function/procedure bodies
- assigning `resolved_type`
- assigning `symbol_ref`
- checking constructor calls
- verifying builtin procedures like `print`

#### `Environment::VerificationContext`

`VerificationContext` holds mutable semantic traversal state such as:

- local scopes
- generic scopes
- current return type
- loop depth
- current module scope

#### `Environment::Global`

`Global` acts as the preloaded semantic environment for things like:

- builtin atomic types
- nominal type references
- type definitions
- builtin procedures/functions

### Current architectural note

Semantic tagging should live on the AST, not in long-lived verifier state consumed by codegen.

That means codegen should read the annotated AST rather than query verifier internals.

---

## Stage 5: Annotated AST

After verification, the compiler effectively operates on an AST that now carries semantic meaning.

Examples of information now present on nodes:

- the resolved type of an expression
- the symbol identity of a declaration
- the symbol identity of an identifier reference

This annotated AST is the contract between semantic analysis and codegen.

---

## Stage 6: Code Generation

### Responsibility

Codegen lowers the verified AST into C code.

### Key files

- [`src/codegen/transpiler.cr`](../src/codegen/transpiler.cr#L9), `DoisC::Codegen::Transpiler`
- [`src/codegen/base_codegen.cr`](../src/codegen/base_codegen.cr#L3), `DoisC::Codegen::BaseCodegen`
- [`src/codegen/emitter.cr`](../src/codegen/emitter.cr#L3), `DoisC::Codegen::Emitter`
- [`src/codegen/type_codegen.cr`](../src/codegen/type_codegen.cr#L3), `DoisC::Codegen::TypeCodegen`
- [`src/codegen/expression_codegen.cr`](../src/codegen/expression_codegen.cr#L6), `DoisC::Codegen::ExpressionCodegen`
- [`src/codegen/function_codegen.cr`](../src/codegen/function_codegen.cr#L3), `DoisC::Codegen::FunctionCodegen`
- [`src/codegen/declaration_codegen.cr`](../src/codegen/declaration_codegen.cr#L3), `DoisC::Codegen::DeclarationCodegen`

### Current structure

Codegen is split by responsibility:

#### `Transpiler`
Orchestrates the overall lowering process. It currently handles:

- emitting runtime include
- emitting top-level declarations
- lowering `proc main` into `dois_main`
- emitting the fixed C `main`

#### `Emitter`
Shared output/formatting object. It is responsible for:

- writing to output
- indentation
- incremental writes vs whole-line writes

All codegen passes should share the same `Emitter` instance.

#### `TypeCodegen`
Maps Dois semantic types to C types.

Examples:

- `Int` → `int64_t`
- `Float` → `double`
- user-defined nominal types → `struct Name`

#### `ExpressionCodegen`
Lowers expressions into C expressions.

Examples:

- literals
- binary expressions
- identifier expressions
- function/procedure calls
- constructor calls
- field access via accessor chains

#### `FunctionCodegen`
Emits statements and function/procedure bodies.

Examples:

- bindings
- expression statements
- returns
- builtin `print` lowering in statement position

#### `DeclarationCodegen`
Emits file-scope declarations.

Examples:

- product types
- union types
- functions
- procedures (except the special `main` lowering path)

### Current codegen invariants

- declarations are emitted at C file scope
- `proc main` lowers to `void dois_main(void)`
- the transpiler emits the C entrypoint wrapper:

```c
int main(void) {
  dois_runtime_init();
  dois_main();
  dois_runtime_shutdown();
  return 0;
}
```

---

## Stage 7: Runtime

### Responsibility

The runtime provides shared C support code that generated programs rely on.

### Main files

- `src/codegen/runtime/runtime.h`
- `src/codegen/runtime/runtime.c`

### Current runtime responsibilities

The runtime currently includes support for:

- arrays
- maps
- result values
- runtime init/shutdown
- primitive printing helpers

Examples:

- `dois_runtime_init`
- `dois_runtime_shutdown`
- `dois_array_new`
- `dois_array_push`
- `dois_map_new`
- `dois_map_put`
- `dois_print_int`
- `dois_print_float`
- `dois_print_bool`
- `dois_print_string`

### Design note

The runtime is included, not generated from scratch each compile.

---

## Stage 8: CLI / Driver

### Responsibility

The CLI coordinates the full pipeline for a source file.

### Main file

- `src/main.cr`

### Responsibilities

- parse command-line args
- read the input file
- run parser
- run type checker
- run transpiler
- write `out.c`
- report errors

---

## Tests

### Main files

- [`spec/integration/parsing_spec.cr`](../spec/integration/parsing_spec.cr)
- [`spec/integration/type_checking_spec.cr`](../spec/integration/type_checking_spec.cr)
- [`spec/unit/type_engine_spec.cr`](../spec/unit/type_engine_spec.cr)
- [`spec/spec_helper.cr`](../spec/spec_helper.cr)

### Current testing focus

Most tests currently target:

- parsing
- type checking
- type engine behavior

End-to-end runtime/codegen tests are still relatively light and should grow over time.

---

## Current Architectural Invariants

These are important assumptions the codebase currently depends on.

### 1. Codegen reads annotated AST

Codegen should use AST annotations like:

- `resolved_type`
- `symbol_ref`

It should not query live verifier state.

### 2. Builtins belong to the global semantic environment

Builtin names like `print` should be registered in `Global` and treated as compiler-known symbols.

### 3. Declarations and executable bodies are lowered separately

Top-level declarations are emitted at file scope.

Executable startup logic is emitted inside `dois_main`.

### 4. Runtime is a shared target

The compiler lowers into C code that depends on `runtime.h` / `runtime.c`.

### 5. Emitter state is shared

All codegen passes must share the same emitter instance so indentation and output state remain consistent.

