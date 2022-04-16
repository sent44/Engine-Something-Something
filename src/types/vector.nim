import std/typetraits
import std/strutils
import std/math


type Vector*[N: static[int], T: SomeNumber] = distinct array[N, T]

type
    Vector2* = Vector[2, float]
    Vector2int* = Vector[2, int]
    Vector3* = Vector[3, float]
    Vector3int* = Vector[3, int]
    Vector4* = Vector[4, float]
    Vector4int* = Vector[4, int]
when defined(typeN):
    type
        VectorN*[N: static[int]] = Vector[N, float]
        VectorNint*[N: static[int]] = Vector[N, int]


template `[]`*[N, T](vector: Vector[N, T], i: int): T = array[N, T](vector)[i]
template `[]=`*[N, T](vector: Vector[N, T], i: int, v: T): void = array[N, T](vector)[i] = v

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


func newVector2*(): Vector2 = newVector[2, float]()
func newVector2*(c: float): Vector2 = newVector[2, float](c)
func newVector2*(x, y: float): Vector2 = newVector[2, float](x, y)
func newVector2int*(): Vector2int = newVector[2, int]()
func newVector2int*(c: int): Vector2int = newVector[2, int](c)
func newVector2int*(x, y: int): Vector2int = newVector[2, int](x, y)
func newVector3*(): Vector3 = newVector[3, float]()
func newVector3*(c: float): Vector3 = newVector[3, float](c)
func newVector3*(x, y, z: float): Vector3 = newVector[3, float](x, y, z)
func newVector3int*(): Vector3int = newVector[3, int]()
func newVector3int*(c: int): Vector3int = newVector[3, int](c)
func newVector3int*(x, y, z: int): Vector3int = newVector[3, int](x, y, z)
func newVector4*(): Vector4 = newVector[4, float]()
func newVector4*(c: float): Vector4 = newVector[4, float](c)
func newVector4*(x, y, z, w: float): Vector4 = newVector[4, float](x, y, z, w)
func newVector4int*(): Vector4int = newVector[4, int]()
func newVector4int*(c: int): Vector4int = newVector[4, int](c)
func newVector4int*(x, y, z, w: int): Vector4int = newVector[4, int](x, y, z, w)
when defined(typeN):
    func newVectorN*[N: static[int]](args: varargs[float]): VectorN[N] = newVector[N, float](args)
    func newVectorNint*[N: static[int]](args: varargs[int]): VectorNint[N] = newVector[N, int](args)

## Arithmetic Operations
template `+`*(a: Vector): Vector = a
func `+`*[N, T](a, b: Vector[N, T]): Vector[N, T] =
    for i in array[N, T](a).len:
        result[i] = a[i] + b[i]
template `+=`*(a: Vector, b: Vector): void = a = a + b

func `-`*[N, T](a: Vector[N, T]): Vector[N, T] =
    for i in array[N, T](a).len:
        result[i] = -a[i]
func `-`*(a, b: Vector): Vector = a + -b
template `-=`*[N, T](a: Vector[N, T], b: Vector[N, T]): void = a = a - b

func `*`*[N, T](a, b: Vector[N, T]): Vector[N, T] =
    for i in array[N, T](a).len:
        result[i] = a[i] * b[i]
func `*`*[N, T](a: Vector[N, T], b: SomeNumber): Vector[N, T] =
    for i in array[N, T](a).len:
        result[i] = a[i] * T(b)
func `*`*[N, T](a: SomeNumber, b: Vector[N, T]): Vector[N, T] =
    for i in array[N, T](b).len:
        result[i] = T(a) * b[i]
template `*=`*[N, T](a: Vector[N, T], b: Vector[N, T]): void = a = a * b
template `*=`*[N, T](a: Vector[N, T], b: SomeNumber): void = a = a * b
func dot*[N, T](a, b: Vector[N, T]): T =
    for i in array[N, T](a).len:
        result += a[i] * b[i]
func cross*[N: static[int], T: SomeFloat](a, b: Vector[N, T]): Vector[N, T] =
    when N != 3 and N != 7:
        raise newException(CatchableError, "Only Vector3 and Vector7 can do cross")
    when N == 7:
        raise newException(CatchableError, "Vector7 is not implement")
    newVector[3, T](a.y*b.z - a.z*b.y, a.z*b.x - a.x*b.z, a.x*b.y - a.y*b.x)

func `/`*[N, T](a, b: Vector[N, T]): Vector[N, T] =
    for i in array[N, T](a).len:
        result[i] = a[i] / b[i]
func `/`*[N, T](a: Vector[N, T], b: SomeNumber): Vector[N, T] =
    for i in array[N, T](a).len:
        result[i] = a[i] / T(b)
# template `/=`*[N, T](a: var Vector[N, T], b: Vector): void = a = a / b
template `/=`*[N, T](a: Vector[N, T], b: SomeNumber): void = a = a / b


## Comparison Operations
func `==`*[N, T](a, b: Vector[N, T]): bool =
    for i in array[N, T](a).len:
        if a[i] != b[i]:
            return false
    return true
func almostEqual*[N: static[int], T: SomeFloat](a, b: Vector[N, T], unitsInLastPlace: Natural = 4): bool =
    for i in array[N, T](a).len:
        if not a[i].almostEqual(b[i], unitsInLastPlace):
            return false
    return true
template `==?`*[N: static[int], T: SomeFloat](a, b: Vector[N, T]): bool = a.almostEqual(b)
template `!=?`*[N: static[int], T: SomeFloat](a, b: Vector[N, T]): bool = not a.almostEqual(b)


## Other Operations
# converter toVector[N: static[int], T: SomeNumber](arr: array[N, T]): Vector[N, T] =
#     result.arr = arr
func toVector*[N: static[int], T: SomeNumber](arr: array[N, T]): Vector[N, T] =
    array[N, T](result) = arr
func castTo*[N, T](`from`: Vector[N, T], toType: typedesc): toType =
    if toType isnot Vector:
        raise newException(CatchableError, "Error, cannot cast to non Vector.")
    for i in min(array[N, T](`from`).len, distinctBase(toType)(result).len):
        result[i] = type(result[0])(`from`[i])

func lengthSquared*[N, T](vector: Vector[N, T]): float =
    result = 0.0
    for i in array[N, T](vector).len:
        result += pow(float(vector[i]), 2.0)
func length*(vector: Vector): float = sqrt(vector.lengthSquared)

func angleTo*(a, b: Vector): float = arccos (a.dot b) / (a.length * b.length)

func normalized*[N: static[int], T: SomeFloat](vector: Vector[N, T]): Vector[N, T] =
    let length = vector.length
    for i in array[N, T](vector).len:
        result[i] = vector[i] / length
func isNormalized*[N: static[int], T: SomeFloat](vector: Vector[N, T]): bool = vector.length == 1.0

func toString*[N, T](vector: Vector[N, T]): string =
    result = "Vector" & $N
    when T isnot float:
        result.add T.name
    result.add "("
    for i in array[N, T](vector).len:
        when T is SomeFloat:
            # TODO Make it system function
            var roundN = intToStr(round(vector[i] * pow(10.float, 6.float)).int, 6)
            var sign = false
            if roundN.startsWith '-':
                sign = true
                roundN.removePrefix '-'
            roundN.insert ".", roundN.len - 6
            for i in 6:
                if roundN.endsWith '0':
                    roundN.removeSuffix '0'
                else:
                    break
            if roundN.startsWith '.':
                roundN.insert "0"
            if roundN.endsWith '.':
                roundN.add "0"
            if sign:
                roundN.insert "-"

            result.add roundN
        else:
            result.add $vector[i]
        result.add ", "
    result.removeSuffix ", "
    result.add ")"
template `$`*(vector: Vector): string = vector.toString()
