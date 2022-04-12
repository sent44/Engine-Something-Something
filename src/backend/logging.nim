{.used.}
{.warning[UnusedImport]: off.}
import std/macros
import std/times

# Copy here for safe keeping
#printColors = stdout.isatty()

type LoggerObj = object
    text: string

# Store log information of log type to broadcast to the one who need
type LoggerDB*[T] = object

type LoggerLevel = enum
    PRINT

proc log*(level: LoggerLevel, info: tuple[filename: string,line: int, column: int], args: varargs[LoggerObj]) = 
    let time = getTime().toUnix
    write(stdout, "[" & $time & "] " & info.filename & ":" & $info.line & " ")
    for arg in args:
        write(stdout, arg.text)
    write(stdout, "\n")

# func loggingToString(x: string|`$`): string = discard

# Magic happen here (might be macro)
macro log*(levelIdent: untyped, args: varargs[untyped]): untyped =
    let statement = newNimNode nnkCall
    statement.add newIdentNode "log"                  # [0]
    statement.add levelIdent                          # [1]
    statement.add newNimNode nnkCall                  # [2]
    statement[2].add newIdentNode "instantiationInfo" # [2][0]

    #** nnkLiterals = {nnkCharLit..nnkNilLit}
    for arg in args:
        let objc = newNimNode nnkObjConstr
        objc.add newIdentNode "LoggerObj"    # [0]
        objc.add newNimNode nnkExprColonExpr # [1]
        objc[1].add newIdentNode "text"      # [1][0]
        if arg.kind == nnkStrLit or (arg.kind == nnkPrefix and arg[0] == ident"$"):
            objc[1].add arg                  # [1][1]
        else:
            objc[1].add newNimNode nnkPrefix # [1][1]
            objc[1][1].add newIdentNode "$"  # [1][1][0]
            objc[1][1].add arg               # [1][1][1]

        statement.add objc                            # [3]

    result = newNimNode nnkStmtList
    result.add statement
    # echo result.astGenRepr


template print*(args: varargs[untyped]) = 
    log(PRINT, args)

import ../types/vector
import std/os
# expandMacros:
    # print "abc", "def"
log LoggerLevel.PRINT,"hi ", newVector[3, float](3.0, 2.5, 4.4), 32
sleep(5000)
print "hello", " hi"

