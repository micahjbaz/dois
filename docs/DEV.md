# Developer Notes

### Known Issues

- Verifier does not fully handle generic scope in match patterns
- some union exhaustiveness checks missing
- many edge case type system specs still failing

### Todo (More in src code)

- Fix verifier generic scope
- add function arity checks
- implement match exhaustiveness

## Next Steps

- Proper AST split: declarations vs executable body
- Expanded expression codegen
- Improved type system handling
- Optional native compilation step
- Module system (lexer, parser, type check, etc.)