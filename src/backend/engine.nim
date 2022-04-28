import window
import event

type
    EngineObj = object
        running: bool
        window: Window
        stopRunningWhenLastWindowIsClosed: bool
        quitCode: int
    EngineSystem* = ref EngineObj

# For storing a copy of reference
var engine: EngineSystem

proc stopRunning(engine: EngineSystem = engine, code: int = 0): void
proc quitEvent(event: Event): void =
    if event.id != 0:
        if engine.window == getWindowFromId(event.id):
            destroyWindow(engine.window)
    else:
        if engine.stopRunningWhenLastWindowIsClosed:
            engine.stopRunning()

proc EngineInit*(createEngineWindow: bool = true, stopWhenLastWindowClose: bool = true): EngineSystem =
    if not engine.isNil:
        raise newException(CatchableError, "Init engine more than once")
    windowSDLInit()
    engine = new EngineSystem
    result = engine

    if createEngineWindow:
        engine.window = createWindow("hi", 128, 64, 512, 64)
    engine.stopRunningWhenLastWindowIsClosed = stopWhenLastWindowClose
    subscribe(WindowQuit, quitEvent)

# proc `=destroy`(x: var EngineObj) =
#     echo "destroy!"

proc run*(engine: EngineSystem): void =
    engine.running = true
    while engine.running:
        pollWindowEvent()


proc stopRunning(engine: EngineSystem = engine, code: int = 0): void =
    engine.running = false
    var event: Event
    event.id = code.uint32
    engine.quitCode = code
    broadcast(EngineStopRunning, event)
    discard


func quit*(engine: EngineSystem): int =
    windowSDLQuit()
    return engine.quitCode

var e = EngineInit()
e.run()
print e.quit()

