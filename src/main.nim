import sdl2
# import std/macros



proc main(): int =
  if not sdl2.init(INIT_VIDEO or INIT_TIMER or INIT_EVENTS):
    sdl2.quit()
    return 1
  let window: WindowPtr = createWindow("Test window", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 640, 400, SDL_WINDOW_SHOWN)
  if window.isNil():
    window.destroy()
    return 1

  var running = true
  var delta: float32
  var counter: uint64
  var previousCounter: uint64
  
  while running:
    echo "running"
    previousCounter = counter
    counter = getPerformanceCounter()
    delta = (counter - previousCounter).float / getPerformanceFrequency().float

    var event: Event = defaultEvent
    while pollEvent(event):
      if event.kind == QuitEvent:
        running = false
      elif event.kind == KeyDown:
        echo "keydown: " & $delta

  

when isMainModule:
  when defined(debug): echo "This is debugging" # Temporary line
  
  quit main()

