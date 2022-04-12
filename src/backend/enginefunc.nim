{.used.}
{.warning[UnusedImport]: off.}
import std/math

func `==?`*[T: SomeFloat](a, b: T): bool = a.almostEqual(b)
template `!=?`*[T: SomeFloat](a, b: T): bool = not a ==? b

iterator items*(n: int): int =
    for i in 0 ..< n:
        yield i
