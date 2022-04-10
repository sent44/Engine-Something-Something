# import std/math
import std/bitops

# Ceil from std/math is not work
func div8(n: int): int =
    result = int n / 8
    if n mod 8 > 0:
        result += 1 

type BitArray*[N: static[int]] = distinct array[div8 N, uint8]

func len*[N](arr: BitArray[N]): int = N

func `[]`*[N](arr: BitArray[N], i: int): bool =
    return array[div8 N, uint8](arr)[div8 i].testBit (i mod 8).uint8
proc `[]=`*[N](arr: var BitArray[N], i: int, value: bool): void =
    if value:
        array[div8 N, uint8](arr)[div8 i].setBit (i mod 8).uint8
        # arr.array[div8 i].setBit (i mod 8).uint8
    else:
        array[div8 N, uint8](arr)[div8 i].clearBit (i mod 8).uint8
        # arr.array[div8 i].clearBit (i mod 8).uint8

# var test: BitArray[9]
# echo test[3]
# test[3] = true
# echo test[3]

# for i in test:
#     echo test[i]

# func newBitArray[N: static[int]](): BitArray[N] =


# echo newBitArray[17]()
