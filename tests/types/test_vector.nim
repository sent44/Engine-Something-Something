discard """
output: '''
Vector2(0.0, 0.0)
Vector2(1.0, 1.0)
Vector2(1.0, 2.0)
Vector2int(2, 2)
true
Vector3int(3, 4, 0)
Vector2(5.0, 7.0)
true
false
true
true
true
true
true
true
false
Vector3(3.2, 4.2, 6.2)
5.0
39.0
Vector3(-3.0, 6.0, -3.0)
'''
"""

import types/vector


echo newVector2()
echo newVector2(1.0)
echo newVector2(1.0, 2.0)
echo newVector2int(2)
echo newVector2(1.0) == newVector2(1.0, 1.0)

echo newVector2(3.5, 4.5).castTo(Vector3int)
echo newVector3int(5, 7, 9).castTo(Vector2)

echo newVector3(4.2, 5.3, -6.4).castTo(Vector4Int) == newVector4Int(4, 5, -6, 0)
echo newVector2(4.0, 3.0) - newVector2(2.0, -1.0) != 2 * newVector2(1.0, 2.0)

let someVector = newVector2(0.3333333333333333, 0.6666666666666667)
echo newVector2(1.0, 2.0) / newVector2(3.0, 3.0) != someVector
echo newVector2(1.0, 2.0) / 3.0 ==? someVector
echo newVector2(1.0, 2.0) / newVector2(3.0, 3.0) !=? someVector + newVector2(0.0, 0.0000000000000011)

echo newVector[8, float]() is VectorN
echo newVector[7, float]() is Vector
echo newVector3(1.0, 2.0, 3.0) is Vector
echo newVector4int(1, 2, 3 ,4) is Vector4

echo [3.2, 4.2, 6.2].toVector()

echo newVector2int(3, 4).length
echo newVector2(3.0, 4.0).dot(newVector2(5.0, 6.0))
echo newVector3(2.0, 3.0, 4.0).cross newVector3(5.0, 6.0, 7.0)

# TODO += -= x=*= /*
