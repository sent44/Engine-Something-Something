include backend/engine

proc main(): int =
  let engine = new EngineSystem
  engine.run()

when isMainModule:
  when defined(debug): echo "This is debugging." # Temporary line
  quit main()
