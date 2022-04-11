import std/math
import std/typetraits

import vector

type Color*[T: SomeFloat] = distinct Vector[4, T]

func `[]`[T](color: Color[T], i: int): T =
    Vector[4, T](color)[i]
func `[]=`[T](color: var Color[T], i: int, v: T): void =
    Vector[4, T](color)[i] = v

func newColor*[T](r: T, g: T, b: T, a: T = T(1.0)): Color[T] =
    Vector[4, T](result) = newVector[4, T](r, g, b, a)
func div255[T](value: int): T
func newColor8*[T](r: int, g: int, b: int, a: int = 255): Color[T] =
    Vector[4, T](result) = newVector[4, T](div255[T] r, div255[T] g, div255[T] b, div255[T] a)


func mul255[T](value: T): int = int (value * 255)
func div255[T](value: int): T = T(value.float/255.0)


func r*[T](color: Color[T]): T = color[0]
func `r=`*[T](color: var Color[T], value: T): void = color[0] = value
func g*[T](color: Color[T]): T = color[1]
func `g=`*[T](color: var Color[T], value: T): void = color[1] = value
func b*[T](color: Color[T]): T = color[2]
func `b=`*[T](color: var Color[T], value: T): void = color[2] = value
func a*[T](color: Color[T]): T = color[3]
func `a=`*[T](color: var Color[T], value: T): void = color[3] = value

func r8*[T](color: Color[T]): int = mul255[T] color[0]
func `r8=`*[T](color: var Color[T], value: int): void = color[0] = div255[T] value
func g8*[T](color: Color[T]): int = mul255[T] color[1]
func `g8=`*[T](color: var Color[T], value: int): void = color[1] = div255[T] value
func b8*[T](color: Color[T]): int = mul255[T] color[2]
func `b8=`*[T](color: var Color[T], value: int): void = color[2] = div255[T] value
func a8*[T](color: Color[T]): int = mul255[T] color[3]
func `a8=`*[T](color: var Color[T], value: int): void = color[3] = div255[T] value


func `+`*(a, b: Color): Color =
    result.vac = a.vac + b.vac
func `-`*(a, b: Color): Color =
    result.vac = a.vac - b.vac
func `*`*(a, b: Color): Color =
    result.vac = a.vac * b.vac


func toString*[T](color: Color[T]): string =
    result = "Color"
    if T isnot float:
        result &= T.name
    result &= "("
    for i in 4:
        result &= $(color[i]).round(6)
        if i < 3:
            result &= ", "
    result &= ")"
func `$`*[T](color: Color[T]): string = color.toString()

# echo newColor(1.2, 2.4, 3.6)
# var aa = newColor8[float](128, 255, 64)
# echo aa
# aa.a = 0.5
# echo aa
# aa.g8 = 128
# echo aa
