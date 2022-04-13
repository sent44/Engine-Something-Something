{.used.}
{.warning[UnusedImport]: off.}
import std/macros
import std/times
import std/typetraits
import std/strutils

#* Copy here for safe keeping
#* printColors = stdout.isatty()
#* nnkLiterals = {nnkCharLit..nnkNilLit}

type LoggerObj* = object
    text: string
    meta: string

# Store log information of log type to broadcast to the one who need
type
    LoggerDB*[T] = ref object
    LoggerEntry* = object

type LoggerLevel* {.pure.} = enum
    PRINT, WARN, INFO, ERROR

# type SystemProcError = object of CatchableError

# Override build-in `$` for object toString 
func `$`[T: tuple | object](obj: T, recursiveCount: int = 0): string =
    when T is tuple:
        result.add "tuple"
    else:
        result.add "object:"
        result.add obj.type.name
    result.add "("
    # NOTE Can be optimize by separate object and tuple loop, maybe?
    for k, v in obj.fieldPairs:
        when T isnot tuple:
            result.add k & ": "
        when v is string:
            result.add v
        else:
            result.add $v
        result.add ", "
    result.removeSuffix ", "
    result.add ")"

proc log*(level: LoggerLevel, info: tuple[filename: string,line: int, column: int], args: varargs[LoggerObj]) = 
    let time = getTime().toUnix
    write(stdout, "[" & $time & "] " & info.filename & ":" & $info.line & " ")
    for arg in args:
        write(stdout, arg.text)
    write(stdout, "\n")

# func loggingToString(x: string|`$`): string = discard

macro log*(levelIdent: untyped, args: varargs[untyped]): untyped =
    let statement = newNimNode nnkCall
    statement.add newIdentNode "log"                  # [0]
    statement.add levelIdent                          # [1]
    statement.add newNimNode nnkCall                  # [2]
    statement[2].add newIdentNode "instantiationInfo" # [2][0]

    for arg in args:
        let objc = newNimNode nnkObjConstr
        objc.add newIdentNode "LoggerObj"    # [0]
        objc.add newNimNode nnkExprColonExpr # [1]
        objc[1].add newIdentNode "text"      # [1][0]
        if arg.kind == nnkStrLit: # or (arg.kind == nnkPrefix and arg[0] == ident"$"):
            objc[1].add arg                  # [1][1]
        elif arg.kind == nnkNilLit:
            objc[1].add newLit "nil"         # [1][1]
        else:
            objc[1].add newNimNode nnkPrefix # [1][1]
            objc[1][1].add newIdentNode "$"  # [1][1][0]
            objc[1][1].add arg               # [1][1][1]
            # NOTE Maybe attach meta to objc?, type?

        statement.add objc                            # [3]

    result = newNimNode nnkStmtList
    result.add statement
    # echo result.astGenRepr


template print*(args: varargs[untyped]) = log(PRINT, args)
# template warn*(args: varargs[untyped]) = log(WARN, args)
template printWarn*(args: varargs[untyped]) = log(WARN, args)
template printError*(args: varargs[untyped]) = log(ERROR, args)
template printInfo*(args: varargs[untyped]) = log(INFO, args)
