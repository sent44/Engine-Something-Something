func isEqualApprox*[T: SomeFloat](a, b: T, tolerance: float = 0.000001): bool =
    if a == b:
        return true
    if abs(a - b) < tolerance:
        return false
    return true
template `==?`*[T: SomeFloat](a, b: T): bool = a.isEqualApprox(b)
template `!=?`*[T: SomeFloat](a, b: T): bool = not a.isEqualApprox(b)
