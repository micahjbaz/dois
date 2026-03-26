require "../spec_helper"

describe DoisC::TypeChecking do
  
  it "accepts a simple valid program" do
    check <<-DOIS
      let x = 5;
    DOIS
  end

  it "accepts simple function usage" do
    check <<-DOIS
      fn add $ (a : Int, b : Int) : Int =>
        a + b
      end

      let x = add$(1, 2);
    DOIS
  end

  it "rejects invalid assignment" do
    expect_type_error <<-DOIS
      let x : Int = "hello";
    DOIS
  end

  it "rejects invalid function call arguments" do
    expect_type_error <<-DOIS
      fn add $ (a : Int, b : Int) : Int =>
        a + b
      end

      let x = add$(1, "oops");
    DOIS
  end

  it "handles generics with Maybe" do
    check <<-DOIS
      type Some<T> has value : T end
      type Maybe<T> is Some(T) | Nil end

      let a = Some(value = 3);
      let b : Maybe(Int) = a;
    DOIS
  end

  it "handles control flow returning unions" do
    check <<-DOIS
      type Some<T> has value : T end
      type Maybe<T> is Some(T) | Nil end

      fn test $ (x : Int) : Maybe(Int) =>
        if x == 0 then
          nil
        else
          Some(x)
        end
      end
    DOIS
  end

  it "handles generic function identity" do
    check <<-DOIS
      fn id<T> $ (x : T) : T =>
        x
      end

      let a = id$(5);
    DOIS
  end

  it "rejects mismatched generic usage" do
    expect_type_error <<-DOIS
      fn id<T> $ (x : T) : T =>
        x
      end

      let a : String = id$(5);
    DOIS
  end

  it "handles generic structs" do
    check <<-DOIS
      type Point<T> has x : T, y : T end

      let p = Point(x = 1, y = 2);
      let q : Point(Int) = p;
    DOIS
  end

  it "rejects incorrect generic struct assignment" do
    expect_type_error <<-DOIS
      type Point<T> has x : T, y : T end

      let p = Point(x = 1, y = 2);
      let q : Point(String) = p;
    DOIS
  end

  it "handles nested generics" do
    check <<-DOIS
      type Some<T> has value : T end

      let x = Some(value = Some(value = 5));
    DOIS
  end

  it "handles match expressions correctly" do
    check <<-DOIS
      type Some<T> has value : T end
      type Maybe<T> is Some(T) | Nil end

      fn unwrap $ (m : Maybe(Int)) : Int =>
        match m then
          Some(value = v) => v,
          Nil => 0
        end
      end
    DOIS
  end

  it "rejects invalid match patterns" do
    expect_type_error <<-DOIS
      type Some<T> has value : T end
      type Maybe<T> is Some(T) | Nil end

      fn bad $ (m : Maybe(Int)) : Int =>
        match m then
          Some(value = v) => "oops",
          Nil => 0
        end
      end
    DOIS
  end

  it "rejects missing match cases if required" do
    expect_type_error <<-DOIS
      type Some<T> has value : T end
      type Maybe<T> is Some(T) | Nil end

      fn bad $ (m : Maybe(Int)) : Int =>
        match m then
          Some(value = v) => v
        end
      end
    DOIS
  end

  it "handles function returning generic types" do
    check <<-DOIS
      type Some<T> has value : T end

      fn wrap<T> $ (x : T) : Some(T) =>
        Some(x)
      end

      let x = wrap$(5);
    DOIS
  end

  it "rejects invalid return types" do
    expect_type_error <<-DOIS
      fn bad $ () : Int =>
        "not an int"
      end
    DOIS
  end

  it "handles chained function calls with types" do
    check <<-DOIS
      fn add $ (a : Int, b : Int) : Int =>
        a + b
      end

      fn double $ (x : Int) : Int =>
        add$(x, x)
      end

      let y = double$(5);
    DOIS
  end

  it "enforces consistent generic usage across parameters" do
    expect_type_error <<-DOIS
      fn pair<T> $ (a : T, b : T) : T =>
        a
      end

      let x = pair$(1, "oops");
    DOIS
  end

  it "propagates generics through multiple functions" do
    check <<-DOIS
      fn id<T> $ (x : T) : T =>
        x
      end

      fn wrap<T> $ (x : T) : T =>
        id$(x)
      end

      let y = wrap$(5);
    DOIS
  end

  it "rejects using union without matching" do
    expect_type_error <<-DOIS
      type Some<T> has value : T end
      type Maybe<T> is Some(T) | Nil end

      fn bad $ (m : Maybe(Int)) : Int =>
        m
      end
    DOIS
  end

  it "binds pattern variables with correct types" do
    check <<-DOIS
      type Some<T> has value : T end
      type Maybe<T> is Some(T) | Nil end

      fn test $ (m : Maybe(Int)) : Int =>
        match m then
          Some(value = v) => v + 1,
          Nil => 0
        end
      end
    DOIS
  end

  it "rejects incorrect constructor field types" do
    expect_type_error <<-DOIS
      type Point<T> has x : T, y : T end

      let p = Point(x = 1, y = "oops");
    DOIS
  end

  it "handles multiple generic instantiations independently" do
    check <<-DOIS
      fn id<T> $ (x : T) : T =>
        x
      end

      let a = id$(5);
      let b = id$("hello");
    DOIS
  end

  it "rejects wrong number of arguments in function call" do
    expect_type_error <<-DOIS
      fn add $ (a : Int, b : Int) : Int =>
        a + b
      end

      let x = add$(1);
    DOIS
  end

  it "rejects wrong number of type arguments in generic type" do
    expect_type_error <<-DOIS
      type Point<T> has x : T, y : T end

      let p : Point = Point(x = 1, y = 2);
    DOIS
  end

  it "handles nested function calls with generics" do
    check <<-DOIS
      fn id<T> $ (x : T) : T =>
        x
      end

      let x = id$(id$(5));
    DOIS
  end

  it "rejects incompatible binary operations" do
    expect_type_error <<-DOIS
      let x = 1 + "hello";
    DOIS
  end

end