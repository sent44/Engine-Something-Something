# import OS
import std/macros

# Copy here for safe keeping
#printColors = stdout.isatty()

# Store log information of log type
type LogObj*[T] = object

# Main magic happen here (might be macro)
func logging*(level: auto, args: varargs[auto]) = discard

# generic print func/macro/template/whatever.
macro print*(): untyped = quote do: discard

# write(stdout, "test stdout")
# write(stdout, "test again")
