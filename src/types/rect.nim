import std/typetraits

import vector

type Rect*[N: static[int], T: SomeNumber] = object
    position*: Vector[N, T]
    size*: Vector[N, T]

type
    Rect2* = Rect[2, float]
    Rect2int* = Rect[2, int]
    Rect3* = Rect[3, float]
    Rect3int* = Rect[3, int]
    Rect4* = Rect[4, float]
    Rect4int* = Rect[4, int]
when defined(typeN):
    type
        RectN*[N: static[int]] = Rect[N, float]
        RectNint*[N: static[int]] = Rect[N, int]

template `end`*(rect: Rect): Vector = rect.position + rect.size
template `end=`*[N, T](rect: var Rect[N, T], pos: Vector[N, T]): void = rect.size = pos - rect.position


func newRect*[N: static[int], T: SomeNumber](args: varargs[T]): Rect[N, T] =
    if args.len != N * 2:
        raise newException(CatchableError, "args count is not 2 times of rect size")
    var pos, size : array[N, T]
    for i in 0 ..< N:
        pos[i] = args[i]
        size[i] = args[i + N]
    result.position = newVector[N, T](pos)
    result.size = newVector[N, T](size)
func newRect*[N: static[int], T: SomeNumber](pos, size: Vector[N, T]): Rect[N, T] = Rect[N, T](position: pos, size: size)


func toString*[N, T](rect: Rect[N, T]): string =
    result = "Rect" & $N
    if T isnot float:
        result &= T.name
    result &= "("
    result &= "position: " & $rect.position
    result &= ", size: " & $rect.size
    result &= ")"
func `$`*(rect: Rect): string = rect.toString()

template test(a: varargs[int]) = echo a.len
let aaa = [3, 4, 5]
test(aaa)

echo newRect[2, int](4, 5, 6, 7)
echo newRect[2, int](newVector2int(3, 5), newVector2int(7, 9))
