import std/typetraits
import vector

type Matrix*[N: static[int], M: static[int], T: SomeNumber] = object
    vecs: array[M, Vector[N, T]]

type
    Matrix2* = Matrix[2, 2, float]
    Matrix2int* = Matrix[2, 2, int]
    Matrix3* = Matrix[3, 3, float]
    Matrix3int* = Matrix[3, 3, int]
    Matrix4* = Matrix[4, 4, float]
    Matrix4int* = Matrix[4, 4, int]

    MatrixN*[N: static[int]] = Matrix[N, N, float]
    MatrixNint*[N: static[int]] = Matrix[N, N, int]


template `[]`*[N, M, T](matrix: Matrix[N, M, T], m: int): Vector[N, T] = matrix.vecs[m] # Matrix[m, n]
template `[]`*[N, M, T](matrix: Matrix[N, M, T], m: int, n: int): T = matrix[m][n] # Matrix[m][n]
template `[]=`*[N, M, T](matrix: Matrix[N, M, T], m: int, value: Vector[N, T]): void = matrix.vecs[m] = value
template`[]=`*[N, M, T](matrix: Matrix[N, M, T], m: int, n: int, value: T): void = matrix.vec[M][N] = value


func newMatrix*[N: static[int], M: static[int], T: SomeNumber](args: varargs[Vector[N, T]]): Matrix[N, M, T] =
    if N < 2 or M < 2:
        raise newException(CatchableError, "Too low")
    if args.len != M:
        raise newException(CatchableError, "Not match number")
    for i, v in args:
        result[i] = v


func castTo*(`from`: Matrix, to_type: typedesc): to_type =
    if toType.genericHead isnot Matrix.genericHead:
        raise newException(CatchableError, "Error, cannot cast to non Matrix.")
    for i in 0 ..< min(`from`.vecs.len, result.vecs.len):
        result[i] = `from`[i].castTo(type(result[0]))
        discard


proc det*[N: static[int], M: static[int], T: SomeNumber](matrix: Matrix[N, M, T]): float =
    if N != M:
        raise newException(CatchableError, "Not square matrix")
    result = 1.0
    # NOTE Repurpose for numerical methods?
    var mat = matrix.castTo(Matrix[N, M, float])
    for i in 0 ..< M - 1:
        var value = mat[i, i]
        mat[i] /= value
        for j in i+1 ..< N:
            mat[j] -= mat[i] * mat[j, i]
        mat[i] *= value
        result *= mat[i, i]
    result *= mat[N-1, N-1]

func toString*[N, M, T](matrix: Matrix[N, M, T]): string =
    result = "Matrix"
    if N == M:
        result &= $N
    else:
        result &= "[" & $N & "x" & $M & "]"
    if T isnot float:
        result &= T.name
    result &= "("
    for i in 0 ..< M:
        result &= $matrix[i]
        if i != M - 1:
            result &= ", "
    result &= ")"
template `$`*(matrix: Matrix): string = matrix.toString()


# echo newMatrix[3, 2, float](newVector3(3.0, 2.0, 5.0), newVector3(1.0, 4.0, 6.0)).castTo(Matrix[2, 2, int])
echo newMatrix[5, 5, int](newVector[5, int](25, 24, 23, 22, 21), newVector[5, int](70, 89, 16, 35, 42), newVector[5, int](50, 51, 52, 53, 54), newVector[5, int](49, 63, 72, 81, 90), newVector[5, int](14, 13, 12, 13, 14)).det()
