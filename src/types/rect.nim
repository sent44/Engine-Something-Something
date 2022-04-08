import vector

type Rect*[N: static[int], T: SomeNumber] = object
    position*: Vector[N, T]
    size*: Vector[N, T]

template `end`*(rect: Rect): Vector = rect.position + rect.size
func `end=`*[N, T](rect: var Rect[N, T], pos: Vector[N, T]): void = rect.size = pos - rect.position
