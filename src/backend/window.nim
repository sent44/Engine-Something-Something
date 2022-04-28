import sdl2

import event as EventSystem

import ../types/vector
import ../types/rect

func windowSDLInit*(): void =
    if not sdl2.init(INIT_VIDEO or INIT_TIMER or INIT_EVENTS):
        sdl2.quit()
        raise newException(CatchableError, $sdl2.getError())

func windowSDLQuit*(): void =
    sdl2.quit()

type Window* = object
    window: WindowPtr

func getWindow*(window: Window): WindowPtr = window.window

func createWindow*(title: string, x, y, width, height: int): Window =
    result.window = sdl2.createWindow(title.cstring, x.cint, y.cint, width.cint, height.cint, SDL_WINDOW_SHOWN)
template createWindow*(title: string, position, size: Vector2int): Window =
    createWindow(title, position.x, position.y, size.x, size.y)
template createWindow*(title: string, rect: Rect2int): Window =
    createWindow(title, rect.position.x, rect.position.y, rect.size.x, rect.size.y)

func destroyWindow*(window: Window): void =
    sdl2.destroyWindow(window.window)

proc pollWindowEvent*(): void =
    var event: sdl2.Event = sdl2.defaultEvent
    while sdl2.pollEvent(event):
        case event.kind:
        of WindowEvent:
            var cbEvent: EventSystem.Event
            cbEvent.id = event.window.windowID
            if event.window.event == WindowEvent_Close:
                broadcast(WindowQuit, cbEvent)
        of QuitEvent:
            var cbEvent: EventSystem.Event
            broadcast(WindowQuit, cbEvent)
        else:
            discard

# func getWindowPtrFromID*(id: uint32): WindowPtr =
#     sdl2.getWindowFromID(id)
func getWindowFromId*(id: uint32): Window =
    result.window = sdl2.getWindowFromID(id)
