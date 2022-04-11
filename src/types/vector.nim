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
when defined(typeN):
    type
        VectorN*[N: static[int]] = Vector[N, float]
        VectorNint*[N: static[int]] = Vector[N, int]


template `[]`*[N, T](vector: Vector[N, T], i: int): T = vector.arr[i]
template `[]=`*[N, T](vector: Vector[N, T], i: int, v: T): void = vector.arr[i] = v

template x*[N, T](vector: Vector[N, T]): T = vector[0]
template `x=`*[N, T](vector: Vector[N, T], v: T): void = vector[0] = v
template y*[N, T](vector: Vector[N, T]): T = vector[1]
template `y=`*[N, T](vector: Vector[N, T], v: T): void = vector[1] = v
template z*[N, T](vector: Vector[N, T]): T = vector[2]
template `z=`*[N, T](vector: Vector[N, T], v: T): void = vector[2] = v
template w*[N, T](vector: Vector[N, T]): T = vector[3]
template `w=`*[N, T](vector: Vector[N, T], v: T): void = vector[3] = v


func newVector*[N: static[int], T: SomeNumber](args: varargs[T]): Vector[N, T] =
    if args.len != 0 and args.len != 1 and N != args.len:
        raise newException(CatchableError, "Not match number")
    if args.len == 1:
        for i in 0 ..< N:
            result[i] = args[0]
    else:
        for i, v in args:
            result[i] = v


template newVector2*(): Vector = newVector[2, float]()
template newVector2*(c: float): Vector = newVector[2, float](c)
template newVector2*(x, y: float): Vector = newVector[2, float](x, y)
template newVector2int*(): Vector = newVector[2, int]()
template newVector2int*(c: int): Vector = newVector[2, int](c)
template newVector2int*(x, y: int): Vector = newVector[2, int](x, y)
template newVector3*(): Vector = newVector[3, float]()
template newVector3*(c: float): Vector = newVector[3, float](c)
template newVector3*(x, y, z: float): Vector = newVector[3, float](x, y, z)
template newVector3int*(): Vector = newVector[3, int]()
template newVector3int*(c: int): Vector = newVector[3, int](c)
template newVector3int*(x, y, z: int): Vector = newVector[3, int](x, y, z)
template newVector4*(): Vector = newVector[4, float]()
template newVector4*(c: float): Vector = newVector[4, float](c)
template newVector4*(x, y, z, w: float): Vector = newVector[4, float](x, y, z, w)
template newVector4int*(): Vector = newVector[4, int]()
template newVector4int*(c: int): Vector = newVector[4, int](c)
template newVector4int*(x, y, z, w: int): Vector = newVector[4, int](x, y, z, w)
when defined(typeN):
    template newVectorN*[N: static[int]](): Vector = newVector[N, float]()
    template newVectorN*[N: static[int]](c: float): Vector = newVector[N, float](c)
    template newVectorN*[N: static[int]](args: varargs[float]) = newVector[N, float][args]
    template newVectorNint*[N: static[int]](): Vector = newVector[N, int]()
    template newVectorNint*[N: static[int]](c: int): Vector = newVector[N, int](c)
    template newVectorNint*[N: static[int]](args: varargs[int]) = newVector[N, int][args]

## Arithmetic Operations
template `+`*(a: Vector): Vector = a
func `+`*(a, b: Vector): Vector =
    for i in 0 ..< a.arr.len:
        result[i] = a[i] + b[i]
template `+=`*(a: var Vector, b: Vector): void = a = a + b

func `-`*(a: Vector): Vector =
    for i in 0 ..< a.arr.len:
        result[i] = -a[i]
func `-`*(a, b: Vector): Vector = a + -b
template `-=`*[N, T](a: var Vector[N, T], b: Vector[N, T]): void = a = a - b

func `*`*(a, b: Vector): Vector =
    for i in 0 ..< a.arr.len:
        result[i] = a[i] * b[i]
func `*`*[N, T](a: Vector[N, T], b: SomeNumber): Vector[N, T] =
    for i in 0 ..< a.arr.len:
        result[i] = a[i] * T(b)
func `*`*[N, T](a: SomeNumber, b: Vector[N, T]): Vector[N, T] =
    for i in 0 ..< b.arr.len:
        result[i] = T(a) * b[i]
template `*=`*[N, T](a: var Vector[N, T], b: Vector[N, T]): void = a = a * b
template `*=`*[N, T](a: var Vector[N, T], b: SomeNumber): void = a = a * b
func dot*[N, T](a, b: Vector[N, T]): T =
    for i in 0 ..< a.arr.len:
        result += a[i] * b[i]
func cross*[N: static[int], T: SomeFloat](a, b: Vector[N, T]): Vector[N, T] =
    when N != 3 and N != 7:
        raise newException(CatchableError, "Only Vector3 and Vector7 can do cross")
    when N == 7:
        raise newException(CatchableError, "Vector7 is not implement")
    newVector[3, T](a.y*b.z - a.z*b.y, a.z*b.x - a.x*b.z, a.x*b.y - a.y*b.x)

func `/`*(a, b: Vector): Vector =
    for i in 0 ..< a.arr.len:
        result[i] = a[i] / b[i]
func `/`*[N, T](a: Vector[N, T], b: SomeNumber): Vector[N, T] =
    for i in 0 ..< a.arr.len:
        result[i] = a[i] / T(b)
# template `/=`*[N, T](a: var Vector[N, T], b: Vector): void = a = a / b
template `/=`*[N, T](a: var Vector[N, T], b: SomeNumber): void = a = a / b


## Comparison Operations
func `==`*(a, b: Vector): bool =
    for i in 0 ..< a.arr.len:
        if a[i] != b[i]:
            return false
    return true
func almostEqual*[N: static[int], T: SomeFloat](a, b: Vector[N, T], unitsInLastPlace: Natural = 4): bool =
    for i in 0 ..< a.arr.len:
        if not a[i].almostEqual(b[i], unitsInLastPlace):
            return false
    return true
template `==?`*[N: static[int], T: SomeFloat](a, b: Vector[N, T]): bool = a.almostEqual(b)
template `!=?`*[N: static[int], T: SomeFloat](a, b: Vector[N, T]): bool = not a.almostEqual(b)


## Other Operations
# converter toVector[N: static[int], T: SomeNumber](arr: array[N, T]): Vector[N, T] =
#     result.arr = arr
func toVector*[N: static[int], T: SomeNumber](arr: array[N, T]): Vector[N, T] =
    result.arr = arr
func castTo*(`from`: Vector, toType: typedesc): toType =
    if toType.genericHead isnot Vector.genericHead:
        raise newException(CatchableError, "Error, cannot cast to non Vector.")
    for i in 0 ..< min(`from`.arr.len, result.arr.len):
        result[i] = type(result[0])(`from`[i])

func lengthSquared*(vector: Vector): float =
    result = 0.0
    for i in 0 ..< vector.arr.len:
        result += pow(float(vector[i]), 2.0)
template length*(vector: Vector): float = sqrt(vector.lengthSquared)

func angleTo*(a, b: Vector): float = arccos (a.dot b) / (a.length * b.length)

func normalized*[N: static[int], T: SomeFloat](vector: Vector[N, T]): Vector[N, T] =
    let length = vector.length
    for i in 0 ..< vector.arr.len:
        result[i] = vector[i] / length
template isNormalized*[N: static[int], T: SomeFloat](vector: Vector[N, T]): bool = vector.length == 1.0

func toString*[N, T](vector: Vector[N, T]): string =
    result = "Vector" & $N
    if T isnot float:
        result &= T.name
    result &= "("
    for i in 0 ..< vector.arr.len:
        when T is SomeFloat:
            result &= $vector[i].round(6)
        else:
            result &= $vector[i]
        if i < N - 1:
            result &= ", "
    result &= ")"
template `$`*(vector: Vector): string = vector.toString()
