# import std/macros

# Import to test these package, will be remove
# import types/vector
# import types/color
# import types/rect

proc main(): int =
  discard

when isMainModule:
  when defined(debug): echo "This is debugging" # Temporary lines
  
  quit main()

