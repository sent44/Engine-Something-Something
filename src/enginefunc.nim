import std/math

func `==?`*[T: SomeFloat](a, b: T): bool = a.almostEqual(b)
template `!=?`*[T: SomeFloat](a, b: T): bool = not a ==? b
