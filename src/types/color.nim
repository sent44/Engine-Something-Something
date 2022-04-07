import std/math
import vector

type Color*[T: SomeFloat] = object
    vec: Vector[4, T]


func newColor*[T](r: T, g: T, b: T, a: T = T(1.0)): Color[T] =
    result.vec = newVector[4, T](r, g, b, a)

template `[]`*[T](color: Color[T], i: int): T = color.vec[i]
template `[]=`*[T](color: Color[T], i: int, v: T): void = color.vec[i] = v

func `+`*(a, b: Color): Color =
    result.vac = a.vac + b.vac
func `-`*(a, b: Color): Color =
    result.vac = a.vac - b.vac
func `*`*(a, b: Color): Color =
    result.vac = a.vac * b.vac


func toString*[T](color: Color[T]): string =
    result = "Color("
    for i in 0 ..< 4:
        result &= $(color.vec[i]).round(6)
        if i < 3:
            result &= ", "
    result &= ")"

template `$`*[T](color: Color[T]): string = color.toString()

echo newColor(1.2, 2.4, 3.6)

