import std/typetraits

import vector

# [Column, Row, Type]
type Matrix*[N: static[int], M: static[int], T: SomeNumber] = distinct array[M, Vector[N, T]]

type
    Matrix2* = Matrix[2, 2, float]
    Matrix2int* = Matrix[2, 2, int]
    Matrix3* = Matrix[3, 3, float]
    Matrix3int* = Matrix[3, 3, int]
    Matrix4* = Matrix[4, 4, float]
    Matrix4int* = Matrix[4, 4, int]
when defined(typeN):
    type
        MatrixN*[N: static[int]] = Matrix[N, N, float]
        MatrixNint*[N: static[int]] = Matrix[N, N, int]


template `[]`*[N, M, T](matrix: Matrix[N, M, T], m: int): Vector[N, T] = # Matrix[m][n]
    array[M, Vector[N, T]](matrix)[m]
template `[]`*[N, M, T](matrix: Matrix[N, M, T], m: int, n: int): T = # Matrix[m, n]
    array[M, Vector[N, T]](matrix)[m][n] 
template `[]=`*[N, M, T](matrix: var Matrix[N, M, T], m: int, value: Vector[N, T]): void =
    array[M, Vector[N, T]](matrix)[m] = value
template `[]=`*[N, M, T](matrix: var Matrix[N, M, T], m: int, n: int, value: T): void =
    array[M, Vector[N, T]](matrix)[m][n] = value

func newMatrix*[N: static[int], M: static[int], T: SomeNumber](args: varargs[Vector[N, T]]): Matrix[N, M, T] =
    if args.len != M:
        raise newException(CatchableError, "Not match number")
    for i, v in args:
        result[i] = v

template newMatrix2*(args: varargs[Vector[2, float]]): Matrix = newMatrix[2, 2, float](args)
template newMatrix2int*(args: varargs[Vector[2, int]]): Matrix = newMatrix[2, 2, int](args)
template newMatrix3*(args: varargs[Vector[3, float]]): Matrix = newMatrix[3, 3, float](args)
template newMatrix3int*(args: varargs[Vector[3, int]]): Matrix = newMatrix[3, 3, int](args)
template newMatrix4*(args: varargs[Vector[4, float]]): Matrix = newMatrix[4, 4, float](args)
template newMatrix4int*(args: varargs[Vector[4, int]]): Matrix = newMatrix[4, 4, int](args)

when defined(typeN):
    template newMatrixN*[N: static[int]](args: varargs[Vector[N, float]]): Matrix = newMatrix[N, N, float](args)
    template newMatrixNint*[N: static[int]](args: varargs[Vector[N, int]]): Matrix = newMatrix[N, N, int](args)

## Arithmetic Operations
# sizeC function is for that don't have to pass generic type 
func sizeC[N, M, T](matrix: Matrix[N, M, T]): int = M

func `+`*(a: Matrix): Matrix = a
func `+`*(a, b: Matrix): Matrix =
    for i in 0 ..< a.sizeC:
        result[i] = a[i] + b[i]
template `+=`*(a: var Matrix, b: Matrix): void = a = a + b

func `-`*(a: Matrix): Matrix =
    for i in 0 ..< a.sizeC:
        result[i] = -a[i]
func `-`*(a, b: Matrix): Matrix = a + -b
template `-=`*(a: var Matrix, b: Matrix): void = a = a - b

func dot*[N1, M1, N2, M2, T](a: Matrix[N1, M1, T], b: Matrix[N2, M2, T]): Matrix[N2, M1, T] =
    if N1 != M2:
        raise newException(CatchableError, "N1 != M2")
    for i in  0 ..< N2:
        for j in  0 ..< M1:
            result[j, i] = T(0)
            for k in 0 ..< N1:
                result[j, i] = result[j, i] + a[j, k] * b[k, i]
func cross*(a, b: Matrix): Vector =
    raise newException(CatchableError, "Use Vector version dammit!")
func `*`*[N1, M1, N2, M2, T](a: Matrix[N1, M1, T], b: Matrix[N2, M2, T]): Matrix[N2, M1, T] = a.dot(b)
template `*=`*[N, T](a: var Matrix[N, N, T], b: Matrix[N, N, T]): void = a = a * b


## Comparison Operations
func `==`*[N, M, T](a, b: Matrix[N, M, T]): bool =
    array[M, Vector[N, T]](a) == array[M, Vector[N, T]](b)
func almostEqual*[N, M, T](a, b: Matrix[N, M, T]): bool =
    for i in M:
        if not array[M, Vector[N, T]](a)[i].almostEqual(array[M, Vector[N, T]](b)[i]):
            return false
    return true
template `==?`*[N, M, T](a, b: Matrix[N, M, T]): bool = a.almostEqual(b)
template `!=?`*[N, M, T](a, b: Matrix[N, M, T]): bool = not a.almostEqual(b)


## Other Operations
func castTo*(`from`: Matrix, to_type: typedesc): to_type =
    if toType.genericHead isnot Matrix.genericHead:
        raise newException(CatchableError, "Error, cannot cast to non Matrix.")
    for i in min(`from`.sizeC, result.sizeC):
        result[i] = `from`[i].castTo(type(result[0]))

func det*[N: static[int], M: static[int], T: SomeNumber](matrix: Matrix[N, M, T]): float =
    if N != M:
        raise newException(CatchableError, "Not square matrix")
    result = 1.0
    # NOTE Repurpose for numerical methods?
    var mat = matrix.castTo(Matrix[N, M, float])
    for i in M - 1:
        var value = mat[i, i]
        mat[i] = mat[i] / value
        for j in i+1 ..< N:
            mat[j] -= mat[i] * mat[j, i]
        mat[i] = mat[i] * value
        result *= mat[i, i]
    result *= mat[N-1, N-1]

func toString*[N, M, T](matrix: Matrix[N, M, T]): string =
    result = "Matrix"
    when N == M:
        result.add $N
    else:
        result.add "[" & $N & "x" & $M & "]"
    if T isnot float:
        result.add T.name
    result.add "("
    for i in 0 ..< M:
        result &= $matrix[i]
        if i != M - 1:
            result.add ", "
    result.add ")"
template `$`*(matrix: Matrix): string = matrix.toString()
