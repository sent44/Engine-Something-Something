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
    if args.len == 0:
        return
    if args.len != N * 2:
        raise newException(CatchableError, "args count is not 2 times of rect size")
    var pos, size : array[N, T]
    for i in 0 ..< N:
        pos[i] = args[i]
        size[i] = args[i + N]
    result.position = newVector[N, T](pos)
    result.size = newVector[N, T](size)
func newRect*[N: static[int], T: SomeNumber](position, size: Vector[N, T]): Rect[N, T] = Rect[N, T](position: position, size: size)
func newRect*[N: static[int], T: SomeNumber](position: Vector[N, T]): Rect[N, T] = Rect[N, T](position: position, size: newVector[N, T]())
func newRect*[N: static[int], T: SomeNumber](size: Vector[N, T]): Rect[N, T] = Rect[N, T](position: newVector[N, T](), size: size)


func newRect2*(): Rect2 = newRect[2, float]()
func newRect2*(x, y, width, height: float): Rect2 = newRect[2, float](x, y, width, height)
func newRect2*(position, size: Vector2): Rect2 = newRect[2, float](position, size)
func newRect2*(position: Vector2): Rect2 = newRect[2, float](position = position)
func newRect2*(size: Vector2): Rect2 = newRect[2, float](size = size)
func newRect2int*(): Rect2int = newRect[2, int]()
func newRect2int*(x, y, width, height: int): Rect2int = newRect[2, int](x, y, width, height)
func newRect2int*(position, size: Vector2int): Rect2int = newRect[2, int](position, size)
func newRect2int*(position: Vector2int): Rect2int = newRect[2, int](position = position)
func newRect2int*(size: Vector2int): Rect2int = newRect[2, int](size = size)
func newRect3*(): Rect3 = newRect[3, float]()
func newRect3*(x, y, z, width, height, depth: float): Rect3 = newRect[3, float](x, y, z, width, height, depth)
func newRect3*(position, size: Vector3): Rect3 = newRect[3, float](position, size)
func newRect3*(position: Vector3): Rect3 = newRect[3, float](position = position)
func newRect3*(size: Vector3): Rect3 = newRect[3, float](size = size)
func newRect3int*(): Rect3int = newRect[3, int]()
func newRect3int*(x, y, z, width, height, depth: int): Rect3int = newRect[3, int](x, y, z, width, height, depth)
func newRect3int*(position, size: Vector3int): Rect3int = newRect[3, int](position, size)
func newRect3int*(position: Vector3int): Rect3int = newRect[3, int](position = position)
func newRect3int*(size: Vector3int): Rect3int = newRect[3, int](size = size)
func newRect4*(): Rect4 = newRect[4, float]()
func newRect4*(x, y, z, w, width, height, depth, wl: float): Rect4 = newRect[4, float](x, y, z, w, width, height, depth, wl)
func newRect4*(position, size: Vector4): Rect4 = newRect[4, float](position, size)
func newRect4*(position: Vector4): Rect4 = newRect[4, float](position = position)
func newRect4*(size: Vector4): Rect4 = newRect[4, float](size = size)
func newRect4int*(): Rect4int = newRect[4, int]()
func newRect4int*(x, y, z, w, width, height, depth, wl: int): Rect4int = newRect[4, int](x, y, z, w, width, height, depth, wl)
func newRect4int*(position, size: Vector4int): Rect4int = newRect[4, int](position, size)
func newRect4int*(position: Vector4int): Rect4int = newRect[4, int](position = position)
func newRect4int*(size: Vector4int): Rect4int = newRect[4, int](size = size)
when defined(typeN):
    func newRectN*[N: static[int]](args: varargs[float]): RectN[N] = newRect[N, float](args)
    func newRectN*[N: static[int]](position, size: VectorN[N]): RectN[N] = newRect[N, float](position, size)
    func newRectN*[N: static[int]](position: VectorN[N]): RectN[N] = newRect[N, float](position = position)
    func newRectN*[N: static[int]](size: VectorN[N]): RectN[N] = newRect[N, float](size = size)
    func newRectNint*[N: static[int]](args: varargs[int]): RectNint[N] = newRect[N, int](args)
    func newRectNint*[N: static[int]](position, size: VectorNint[N]): RectNint[N] = newRect[N, int](position, size)
    func newRectNint*[N: static[int]](position: VectorNint[N]): RectNint[N] = newRect[N, int](position = position)
    func newRectNint*[N: static[int]](size: VectorNint[N]): RectNint[N] = newRect[N, int](size = size)


func abs*[N, T](rect: Rect[N, T]): Rect[N, T] =
    result = rect
    for i in N:
        if result.size[i] < 0:
            result.size[i] *= -1
            result.position[i] -= result.size[i] 

func getVolume*[N, T](rect: Rect[N, T]): T =
    result = 1
    for i in N:
        result *= rect.size[i]
template getArea*(rect: Rect2): float = rect.getVolume
template getArea*(rect: Rect2int): int = rect.getVolume


func `==`*(a, b: Rect): bool = a.position == b.position and a.size == b.size
func almostEqual*(a, b: Rect): bool = a.position.almostEqual(b.position) and a.size.almostEqual(b.size)
template `==?`*(a, b: Rect): bool = a.almostEqual(b)
template `!=?`*(a, b: Rect): bool = not a.almostEqual(b)


func toString*[N, T](rect: Rect[N, T]): string =
    result = "Rect" & $N
    when T isnot float:
        result &= T.name
    result.add  "("
    result.add "position: " & $rect.position
    result.add ", size: " & $rect.size
    result.add ")"
template `$`*(rect: Rect): string = rect.toString()


# print newRect3(size = newVector3(3.0, 4.0, 5.0)).getVolume
# print newRect2(position = newVector2(3.0, 5.0))


# template test(a: varargs[int]) = echo a.len
# let aaa = [3, 4, 5]
# test(aaa)

echo newRect[2, float](4.0, 5.0, -6.0, -7.0).abs()
# echo newRect[2, int](newVector2int(3, 5), newVector2int(7, 9))
