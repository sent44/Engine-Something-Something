import backend/engine

proc main(): int =
  let engine = new EngineSystem
  engine.run()

when isMainModule:
  when defined(debug): info "This is debugging." # Temporary line
  quit main()
