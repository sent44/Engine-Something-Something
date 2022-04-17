import window
# import event

type
    EngineObj = object
        running: bool
        quitCode: int
    EngineSystem* = ref EngineObj

# var win: Window

var isEngineQuit: bool = false

# proc quitEvent(event: Event): void =
#     if event.id != 0:
#         if win.getWindow == getWindowFromId(event.id):
#             destroyWindow(win)
#     else:
#         print "still else"

func EngineInit*(): EngineSystem =
    result = new EngineSystem
    windowSDLInit()

    # win = createWindow("hi", 128, 64, 512, 64)
    # subscribe(EventChannel.WindowQuit, quitEvent)

# proc `=destroy`(x: var EngineObj) =
#     echo "destroy!"

proc run*(engine: EngineSystem): void =
    while not isEngineQuit:
        pollWindowEvent()


func quit*(engine: EngineSystem): int =
    windowSDLQuit()
    return engine.quitCode
