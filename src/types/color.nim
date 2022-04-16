import std/math
import std/typetraits

import vector

type Color*[T: SomeFloat] = distinct Vector[4, T]

template `[]`[T](color: Color[T], i: int): T =
    Vector[4, T](color)[i]
template `[]=`[T](color: var Color[T], i: int, v: T): void =
    Vector[4, T](color)[i] = v

template mul255[T](value: T): int = int (value * 255)
template div255[T](value: int): T = T(value.float/255.0)

func newColor*[T](r: T, g: T, b: T, a: T = T(1.0)): Color[T] =
    Vector[4, T](result) = newVector[4, T](r, g, b, a)
func newColor8*[T](r: int, g: int, b: int, a: int = 255): Color[T] =
    Vector[4, T](result) = newVector[4, T](div255[T] r, div255[T] g, div255[T] b, div255[T] a)





template r*[T](color: Color[T]): T = color[0]
template `r=`*[T](color: var Color[T], value: T): void = color[0] = value
template g*[T](color: Color[T]): T = color[1]
template `g=`*[T](color: var Color[T], value: T): void = color[1] = value
template b*[T](color: Color[T]): T = color[2]
template `b=`*[T](color: var Color[T], value: T): void = color[2] = value
template a*[T](color: Color[T]): T = color[3]
template `a=`*[T](color: var Color[T], value: T): void = color[3] = value

template r8*[T](color: Color[T]): int = mul255[T] color[0]
template `r8=`*[T](color: var Color[T], value: int): void = color[0] = div255[T] value
template g8*[T](color: Color[T]): int = mul255[T] color[1]
template `g8=`*[T](color: var Color[T], value: int): void = color[1] = div255[T] value
template b8*[T](color: Color[T]): int = mul255[T] color[2]
template `b8=`*[T](color: var Color[T], value: int): void = color[2] = div255[T] value
template a8*[T](color: Color[T]): int = mul255[T] color[3]
template `a8=`*[T](color: var Color[T], value: int): void = color[3] = div255[T] value


func `+`*[T](a, b: Color[T]): Color[T] = a + b.vac
template `+=`*(a: var Color, b: Color): void = a = Vector[4, T](a) + Vector[4, T](b)
func `-`*[T](a, b: Color[T]): Color[T] = Vector[4, T](a) - Vector[4, T](b)
template `-=`*(a: var Color, b: Color): void = a = a - b
func `*`*[T](a, b: Color[T]): Color[T] = Vector[4, T](a) * Vector[4, T](b)
template `*=`*(a: var Color, b: Color): void = a = a * b


func toString*[T](color: Color[T]): string =
    result = "Color"
    when T isnot float:
        result.add T.name
    result.add "("
    for i in 4:
        result.add $(color[i]).round(6)
        if i < 3:
            result.add ", "
    result.add ")"
template `$`*[T](color: Color[T]): string = color.toString()

# echo newColor(1.2, 2.4, 3.6)
# var aa = newColor8[float](128, 255, 64)
# echo aa
# aa.a = 0.5
# echo aa
# aa.g8 = 128
# echo aa
