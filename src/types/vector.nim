import std/typetraits
import std/math

type Vector*[N: static[int], T: SomeNumber] = object
    arr: array[N, T]

type
    Vector2* = Vector[2, float]
    Vector2int* = Vector[2, int]
    Vector3* = Vector[3, float]
    Vector3int* = Vector[3, int]
    Vector4* = Vector[4, float]
    Vector4int* = Vector[4, int]
    # Extra vector types
    VectorN*[N: static[int]] = Vector[N, float]
    VectorNint*[N: static[int]] = Vector[N, int]


template `[]`*[N, T](vector: Vector[N, T], i: int): T = vector.arr[i]
template `[]=`*[N, T](vector: Vector[N, T], i: int, v: T): void = vector.arr[i] = v
template len*[N, T](vector: Vector[N, T]): int = N

template x*[N, T](vector: Vector[N, T]): T = vector[0]
template `x=`*[N, T](vector: Vector[N, T], v: T): void = vector[0] = v
template y*[N, T](vector: Vector[N, T]): T = vector[1]
template `y=`*[N, T](vector: Vector[N, T], v: T): void = vector[1] = v
template z*[N, T](vector: Vector[N, T]): T = vector[2]
template `z=`*[N, T](vector: Vector[N, T], v: T): void = vector[2] = v
template w*[N, T](vector: Vector[N, T]): T = vector[3]
template `w=`*[N, T](vector: Vector[N, T], v: T): void = vector[3] = v


func newVector*[N: static[int], T: SomeNumber](args: varargs[T]): Vector[N, T] =
    if N < 2:
        raise newException(CatchableError, "Too low")
    if args.len != 0 and N != args.len:
        raise newException(CatchableError, "Not match number")
    for i, v in args:
        result[i] = v
    # result.arr = array[N, T](args)


template newVector2*(): Vector = newVector[2, float]()
template newVector2*(x, y: float): Vector = newVector[2, float](x, y)
template newVector2int*(): Vector = newVector[2, int]()
template newVector2int*(x, y: int): Vector = newVector[2, int](x, y)
template newVector3*(): Vector = newVector[3, float]()
template newVector3*(x, y, z: float): Vector = newVector[3, float](x, y, z)
template newVector3int*(): Vector = newVector[3, int]()
template newVector3int*(x, y, z: int): Vector = newVector[3, int](x, y, z)
template newVector4*(): Vector = newVector[4, float]()
template newVector4*(x, y, z, w: float): Vector = newVector[4, float](x, y, z, w)
template newVector4int*(): Vector = newVector[4, int]()
template newVector4int*(x, y, z, w: int): Vector = newVector[4, int](x, y, z, w)


template `+`*(a: Vector): Vector = a
func `+`*(a, b: Vector): Vector =
    for i in 0 ..< a.len:
        result[i] = a[i] + b[i]

func `-`*(a: Vector): Vector =
    for i in 0 ..< a.len:
        result[i] = -a[i]
template `-`*(a, b: Vector): Vector = a + -b

func `*`*(a, b: Vector): Vector =
    for i in 0 ..< a.len:
        result[i] = a[i] * b[i]
func `*`*[N, T](a: Vector[N, T], b: SomeNumber): Vector[N, T] =
    for i in 0 ..< a.len:
        result[i] = a[i] * T(b)
func `*`*[N, T](a: SomeNumber, b: Vector[N, T]): Vector[N, T] =
    for i in 0 ..< b.len:
        result[i] = T(a) * b[i]
func dot*[N, T](a, b: Vector[N, T]): T =
    for i in 0 ..< a.len:
        result += a[i] * b[i]
func cross*[T](a, b: Vector[3, T]): Vector[3, T] =
    # TODO cross is still empty
    newVector[3, T]()

func `/`*(a, b: Vector): Vector =
    for i in 0 ..< a.len:
        result[i] = a[i] / b[i]
func `/`*[N, T](a: Vector[N, T], b: SomeNumber): Vector[N, T] =
    for i in 0 ..< a.len:
        result[i] = a[i] / T(b)

func `==`*(a, b: Vector): bool =
    for i in 0 ..< a.len:
        if a[i] != b[i]:
            return false
    return true
func `isEqualApprox`*[N: static[int], T: SomeFloat](a, b: Vector[N, T], tolerance: float = 0.000001): bool =
    for i in 0 ..< a.len:
        if a[i] != b[i]:
            if abs(a[i] - b[i]) > tolerance:
                return false
    return true
template `==?`*[N: static[int], T: SomeFloat](a, b: Vector[N, T]): bool = a.isEqualApprox(b)
template `!=?`*[N: static[int], T: SomeFloat](a, b: Vector[N, T]): bool = not a.isEqualApprox(b)


func castTo*(`from`: Vector, to_type: typedesc): to_type =
    if to_type.genericHead isnot Vector.genericHead:
        raise newException(CatchableError, "Error, cannot cast to non TypeVector.")
    for i in 0 ..< min(`from`.len, result.len):
        result[i] = type(result[0])(`from`[i])



func toString*[N, T](vector: Vector[N, T]): string =
    result = "Vector" & $N
    if T isnot float:
        result &= T.name
    result &= "("
    for i in 0 ..< vector.len:
        when T is SomeFloat:
            result &= $vector[i].round(6)
        else:
            result &= $vector[i]
        if i < N - 1:
            result &= ", "
    result &= ")"

template `$`*[N, T](vector: Vector[N, T]): string = vector.toString()


assert newVector2(3.5, 4.5).toString == "Vector2(3.5, 4.5)"
assert newVector3(4.2, 5.3, -6.4).castTo(Vector4Int) == newVector4Int(4, 5, -6, 0)
assert not (newVector2(4.0, 3.0) - newVector2(2.0, -1.0) != 2 * newVector2(1.0, 2.0))
assert newVector[5, uint16]().toString == "Vector5uint16(0, 0, 0, 0, 0)"
assert newVector2(1.0, 2.0) / newVector2(3.0, 3.0) != newVector2(0.333333, 0.666666)
assert newVector2(1.0, 2.0) / newVector2(3.0, 3.0) ==? newVector2(0.333333, 0.666666)
assert newVector2(1.0, 2.0) / newVector2(3.0, 3.0) !=? newVector2(0.333333, 0.666677)
assert newVector[8, float]() is VectorN
assert newVector[7, float]() is Vector
assert newVector3(1.0, 2.0, 3.0) is Vector
assert newVector4int(1, 2, 3 ,4) isnot Vector4
