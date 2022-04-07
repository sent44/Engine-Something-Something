# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.

import std/macros
import types/vector
import types/color

when isMainModule:
  # echo("Hello, World!")
  # for i in 0 ..< 20:
  #   echo "hi!"
  discard
  # expandMacros:
  # var test = Vector2ONE + Vector[int, 3](@[1, 1, 1])
  # echo test
  # echo Vector2(3.2, 2.4) + test + Vector2.ZERO
  # echo Vector[float, 2](test)

# func fnA() =
#   discard

# func fnB() =
#   discard

# expandMacros:
#   # {.experimental: "callOperator".}
#   # macro test(_: int) =
#   #   result = quote do:
#   #     echo 31
#   a ident"hi"
#   # a fnB

# proc test(a, b, c, d:float = 1.1) =
#   echo $a & " " & $b & " " & $c & " " & $d

# test(0.0, 0.1, 0.2)
