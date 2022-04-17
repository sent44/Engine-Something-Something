{.used.}
{.warning[UnusedImport]: off.}
import std/macros
import std/times
import std/typetraits
import std/strutils

# NOTE Copy here for safe keeping
#* printColors = stdout.isatty()
#* nnkLiterals = {nnkCharLit..nnkNilLit}

when defined(debug) or defined(enableLogging):
    type LoggingObj* = object
        text: string
        meta: string

    type LoggingLevel* {.pure.} = enum
        PRINT, WARN, INFO, ERROR

    # Store log information of log type to broadcast to the one whose need
    {.hint[XDeclaredButNotUsed]:off.}
    type
        LoggingEntry = object
            level: LoggingLevel
            time: int64
            # entry: ref UncheckedArray[LoggingObj]
            entry: seq[ref LoggingObj]
        # LoggingDBSection* = object
        #     entry: array[20, LoggingEntry]
        LoggingDB[T] = ref object


# Not warp in `when defined` Because user might use it elsewhere.
# Forward declare for below function
func expandRefObjectString*[T: ref object](obj: T, recursiveCount: int = 0): string
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
func expandRefObjectString*[T: ref object](obj: T, recursiveCount: int = 0): string =
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
            when v is string:
                result.add v
            elif v is ref object:
                result.add expandRefObjectString(v, recursiveCount + 1)
            elif v is object or v is ref object or v is tuple:
                result.add expandObjectString(v, recursiveCount + 1)
            else:
                result.add $v
            result.add ", "
        result.removeSuffix ", "
        result.add ")"
template `?`*[T: tuple | object | ref object](obj: T): string =
    when T is ref object:
        expandRefObjectString(obj)
    else:
        expandObjectString(obj)

# Forward declare override just for below function
func toRefString[T: ref object](obj: T, recursiveCount: int = 0): string 
# Override build-in `$` for object toString 
func toString[T: tuple | object](obj: T, recursiveCount: int = 0): string =
    when T is tuple:
        result.add "tuple"
    else:
        result.add "obj."
        result.add T.name
    result.add "("
    for k, v in obj.fieldPairs:
        when T isnot tuple:
            result.add k & ": "
        when v is string:
            result.add v
        elif v is object or v is ref object or v is tuple:
            result.add toString(v, recursiveCount + 1)
        else:
            result.add $v
        result.add ", "
    result.removeSuffix ", "
    result.add ")"
func toRefString[T: ref object](obj: T, recursiveCount: int = 0): string =
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
            when v is string:
                result.add v
            elif v is ref object:
                result.add toRefString(v, recursiveCount + 1)
            elif v is object or v is ref object or v is tuple:
                result.add toString(v, recursiveCount + 1)
            else:
                result.add $v
            result.add ", "
        result.removeSuffix ", "
        result.add ")"


when defined(debug) or defined(enableLogging):
    # TODO Make it more than just print
    proc log*(level: LoggingLevel, info: tuple[filename: string,line: int, column: int], args: varargs[LoggingObj]) = 
        let time = getTime().toUnix
        write(stdout, "[" & $time & "] " & info.filename & ":" & $info.line & " - ")
        for arg in args:
            write(stdout, arg.text)
        write(stdout, "\n")

    func loggingStringOperation*[T](x: T): string =
        # Normal override `$` can't be use outside of this package
        {.hint[XDeclaredButNotUsed]:off.}
        func `$`[U: tuple | object](obj: U): string =
            return obj.toString
        func `$`[U: ref object](obj: U): string =
            return obj.toRefString
        return $x

    macro log*(levelIdent: untyped, args: varargs[untyped]): untyped =
        let statement = newNimNode nnkCall
        statement.add newIdentNode "log"                  # [0]
        statement.add levelIdent                          # [1]
        statement.add newNimNode nnkCall                  # [2]
        statement[2].add newIdentNode "instantiationInfo" # [2][0]

        for arg in args:
            let objc = newNimNode nnkObjConstr
            objc.add newIdentNode "LoggingObj"                       # [0]
            objc.add newNimNode nnkExprColonExpr                     # [1]
            objc[1].add newIdentNode "text"                          # [1][0]
            if arg.kind == nnkStrLit:
                objc[1].add arg                                      # [1][1]
            elif arg.kind == nnkNilLit:
                objc[1].add newLit "nil"                             # [1][1]
            else:
                objc[1].add newNimNode nnkCall                       # [1][1]
                objc[1][1].add newIdentNode "loggingStringOperation" # [1][1][0]
                objc[1][1].add arg                                   # [1][1][1]

            # else:
            #     objc[1].add newNimNode nnkPrefix                   # [1][1]
            #     objc[1][1].add newIdentNode "$"                    # [1][1][0]
            #     objc[1][1].add arg                                 # [1][1][1]
                # NOTE Maybe attach meta to objc?, type?
            statement.add objc                            # [3]
        
        result = newNimNode nnkStmtList
        result.add statement


when defined(debug) or defined(enableLogging):
    template print*(args: varargs[untyped]) = log(PRINT, args)
    # template warn*(args: varargs[untyped]) = log(WARN, args)
    template printWarn*(args: varargs[untyped]) = log(WARN, args)
    template printError*(args: varargs[untyped]) = log(ERROR, args)
    template printInfo*(args: varargs[untyped]) = log(INFO, args)
else:
    template print*(args: varargs[untyped]) = discard
    template printWarn*(args: varargs[untyped]) = discard
    template printError*(args: varargs[untyped]) = discard
    template printInfo*(args: varargs[untyped]) = discard
