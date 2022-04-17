import backend/engine

proc main(): int =
  let engine = EngineInit()
  engine.run()
  return engine.quit()

when isMainModule:
  when defined(debug): printInfo "This is debugging." # Temporary line
  quit main()
