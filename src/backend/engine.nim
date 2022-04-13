# import sdl2

type
    EngineObj = object
        a: int
    EngineSystem* = ref EngineObj

# proc `=destroy`(x: var EngineObj) =
#     echo "destroy!"

proc run*(engine: EngineSystem): int =
    while true:
        discard

# type aaa = object
#     bbb: int

# func `$`(a: aaa): string = "default"

# var abc: aaa
# echo abc

# proc ccc(r: object) =
#     proc `$`(o: r.type): string = "new output"
#     echo r

# ccc(abc)
