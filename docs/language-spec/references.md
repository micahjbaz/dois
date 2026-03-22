# References

References provide *controlled mutable storage* in Dois. They allow values to be updated after creation, while the rest of the language remains immutable by default.

---

## Core Concept

A reference is a container that holds a value of type `T`.

```
Ref<T>
```

- A `Ref<T>` stores a value of type `T`
- The reference itself is immutable
- The value inside the reference can be mutated

---

## Creating a Reference

References are created using the `ref` keyword:

```
var x : Ref<Int> = ref(10);  # x : Ref<Int>
```

- `ref(expr)` creates a new reference initialized with the value of `expr`
- The resulting value is of type `Ref<T>`

---

## Reading from a Reference

To read the value stored inside a reference, use the `@` operator:

```
let r : Ref<Int> = ref(10);
let v : Int = @r;
```


### Type Rule

- If `x : Ref<T>`, then `@x : T`

---

## Writing to a Reference

To update the value stored inside a reference, use the reference assignment operator `:=`:

### Example

```
var x = ref(10);
x := 20;

println(@x);  # 20
```

### Type Rules

- Left-hand side must be of type `Ref<T>`
- Right-hand side must be of type `T`

---

## Mutability

### Mutation is restricted to procedures

- References may be created in any context
- Mutation (`:=`) is only allowed inside `proc`

```
proc update(r: Ref<Int>) do
  r := @r + 1;
end
```

Attempting mutation inside a `fn` results in a compile-time error.

---

### Functions may read but not mutate references

```
fn read_value(r: Ref<Int>) : Int
  @r
end
```

Valid because it does not modify state.

---

## Reference Identity and Aliasing

References behave like *shared mutable locations*.

```
var a = ref(10);
var b = a;

a := 20;

println(@b);  # 20
```

- `a` and `b` refer to the same underlying storage
- Mutation through one affects the other

---