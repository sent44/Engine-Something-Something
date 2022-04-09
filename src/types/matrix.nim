import vector

type Matrix[N: static[int], M: static[int], T: SomeNumber] = object
    vecs: array[M, Vector[N, T]]


func newMatrix[N: static[int], M: static[int], T: SomeNumber](args: varargs[Vector[N, T]]): Matrix[N, M, T] =
    
    discard


template `[]`[N, M, T](matrix: Matrix[N, M, T], m: int): Vector[N, T] = matrix.vecs[m]
template `[]`[N, M, T](matrix: Matrix[N, M, T], m: int, n: int): T = matrix[m][n]

discard Matrix[3, 3, int]()[2]
