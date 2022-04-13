{.used.}
{.warning[UnusedImport]: off.}
import std/macros
import std/times
import std/typetraits
import std/strutils

#* Copy here for safe keeping
#* printColors = stdout.isatty()
#* nnkLiterals = {nnkCharLit..nnkNilLit}

type LoggingObj* = object
    text: string
    meta: string


type LoggingLevel* {.pure.} = enum
    PRINT, WARN, INFO, ERROR

{.hint[XDeclaredButNotUsed]:off.}
# Store log information of log type to broadcast to the one who need
type
    LoggingEntry = object
        level: LoggingLevel
        time: int64
        # entry: ref UncheckedArray[LoggingObj]
        entry: seq[ref LoggingObj]
    # LoggingDBSection* = object
    #     entry: array[20, LoggingEntry]
    LoggingDB[T] = ref object

# Forward declare override just for below function
proc `$`[T: tuple | object](obj: T, recursiveCount: int = 0): string
proc `$`[T: ref object](obj: T, recursiveCount: int = 0): string =
    if obj.isNil:
        result = "nil"
    else:
        result.add "obj*."
        var name = T.name
        name.removePrefix "ref "
        result.add name
        result.add "("
        for k, v in fieldPairs(obj[]):
            result.add k & ": "
            # echo v is ref object
            when v is string:
                result.add v
            elif v is object or v is ref object or v is tuple:
                result.add $(v, recursiveCount + 1)
            else:
                result.add $v
            result.add ", "
        result.removeSuffix ", "
        result.add ")"

func expandRefObjectString*[T: ref object](obj: T, recursiveCount: int = 0): string =
    if obj.isNil:
        result = "nil"
    else:
        # TODO Too tried to continue
        discard

template `?`*[T: tuple | object](obj: T): string = expandRefObjectString(obj)

# Override build-in `$` for object toString 
proc `$`[T: tuple | object](obj: T, recursiveCount: int = 0): string =
    when T is tuple:
        result.add "tuple"
    else:
        result.add "obj."
        result.add T.name
    result.add "("
    # NOTE Can be optimize by separate object and tuple loop, maybe?
    for k, v in obj.fieldPairs:
        when T isnot tuple:
            result.add k & ": "
        when v is string:
            result.add v
        elif v is object or v is ref object or v is tuple:
            result.add $(v, recursiveCount + 1)
        else:
            result.add $v
        result.add ", "
    result.removeSuffix ", "
    result.add ")"

# For pure object output string (bypass user `$`)
func expandObjectString*[T: tuple | object](obj: T, recursiveCount: int = 0): string =
    when T is tuple:
        result.add "tuple"
    else:
        result.add "obj."
        result.add obj.type.name
    result.add "("
    for k, v in obj.fieldPairs:
        when T isnot tuple:
            result.add k & ": "
        when v is string:
            result.add v
        elif v is object or v is tuple:
            result.add expandObjectString(v, recursiveCount + 1)
        elif v is ref object:
            result.add expandRefObjectString(v, recursiveCount + 1)
        else:
            result.add $v
        result.add ", "
    result.removeSuffix ", "
    result.add ")"

template `?`*[T: tuple | object](obj: T): string = expandObjectString(obj)

proc log*(level: LoggingLevel, info: tuple[filename: string,line: int, column: int], args: varargs[LoggingObj]) = 
    let time = getTime().toUnix
    write(stdout, "[" & $time & "] " & info.filename & ":" & $info.line & " ")
    for arg in args:
        write(stdout, arg.text)
    write(stdout, "\n")

macro log*(levelIdent: untyped, args: varargs[untyped]): untyped =
    let statement = newNimNode nnkCall
    statement.add newIdentNode "log"                  # [0]
    statement.add levelIdent                          # [1]
    statement.add newNimNode nnkCall                  # [2]
    statement[2].add newIdentNode "instantiationInfo" # [2][0]

    for arg in args:
        let objc = newNimNode nnkObjConstr
        objc.add newIdentNode "LoggingObj"    # [0]
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
