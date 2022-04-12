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
