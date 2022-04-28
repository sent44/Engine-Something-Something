import std/bitops

# Ceil from std/math is not work
func div8(n: int): int =
    result = int n / 8
    if n mod 8 > 0:
        result += 1 

type BitArray*[N: static[int]] = distinct array[div8 N, uint8]

func len*[N](arr: BitArray[N]): int = N

func `[]`*[N](arr: BitArray[N], i: int): bool =
    array[div8 N, uint8](arr)[int i/8].testBit (i mod 8).uint8
func `[]=`*[N](arr: var BitArray[N], i: int, value: bool): void =
    if value:
        array[div8 N, uint8](arr)[int i/8].setBit (i mod 8).uint8
    else:
        array[div8 N, uint8](arr)[int i/8].clearBit (i mod 8).uint8

func setAllTrue*(arr: var BitArray): void =
    for i in arr.len:
        arr[i] = true
func setAllFalse*[N](arr: var BitArray[N]): void =
    for i in arr.len:
        arr[i] = false


## Comparison Operations
func any*(arr: BitArray): bool =
    for i in arr.len:
        if arr[i] == true:
            return true
    return false
func all*(arr: BitArray): bool =
    for i in arr.len:
        if arr[i] == false:
            return false
    return true


## Other Operations
func countTrue*(arr: BitArray): int =
    result = 0
    for i in arr.len:
        if arr[i] == true:
            result += 1

iterator items*[N](arr: BitArray[N]): bool =
    for i in arr.len:
        yield arr[i]

converter toBitArray*[N: static[int]](arr: array[N, bool]): BitArray[N] =
    for i, v in arr:
        result[i] = v
converter toArray*[N: static[int]](arr: BitArray[N]): array[N, bool] =
    for i in arr.len:
        result[i] = arr[i]

#converter castTo*() # TODO For resize array

func toString*(arr: BitArray): string =
    result = "́ [" # Acute accent may be hidden here!
    for i in arr.len:
        result.add $arr[i]
        if i < arr.len - 1:
            result.add ", "
    result.add "]"
template `$`*(arr: BitArray): string = arr.toString()

var a: BitArray[3] = [false, true, false]
var b: array[3, bool] = a
print a
print b
