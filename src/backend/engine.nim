# import sdl2

{.hint[XDeclaredButNotUsed]: off.}

type
    EngineObj = object
        a: int
    EngineSystem = ref EngineObj

# proc `=destroy`(x: var EngineObj) =
#     echo "destroy!"

proc run(engine: EngineSystem): int =
    var i = 0
    while true:
        discard
