# Developer Notes

## Type System

- Hindley–Milner style inference
- `TypeVariable.instance` is used for unification
- `prune` must always be called before comparisons

### Generics

- `instantiate` replaces GenericTypeParameter → fresh TypeVariable
- nominal types create fresh args if generics exist
- do not copy types before unify (causes lost bindings)

### Known Issues

- Verifier does not fully handle generic scope in match patterns
- some union exhaustiveness checks missing
- many edge case type system specs still failing

### Todo (More in src code)

- Fix verifier generic scope
- add function arity checks
- implement match exhaustiveness
- Start transpilation to C!