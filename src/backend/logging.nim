{.used.}
{.warning[UnusedImport]: off.}
import std/macros
import std/times

# Copy here for safe keeping
#printColors = stdout.isatty()

type LoggerObj = object
    text: string

# Store log information of log type to broadcast to the one who need
type LoggerResObj*[T] = object

type LoggerLevel = enum
    PRINT

proc logger*(level: LoggerLevel, info: tuple[filename: string,line: int, column: int], args: varargs[LoggerObj]) = 
    let time = getTime().toUnix
    write(stdout, "[" & $time & "] " & info.filename & ":" & $info.line & " ")
    for arg in args:
        write(stdout, arg.text)

# func logObjTree(args: varargs[string or NimNode]): NimNode {.compileTime.} =
#     result = newNimNode nnkObjConstr
#     result.add newIdentNode "LoggerObj"   # [0]
#     result.add newNimNode nnkExprColonExpr

# Magic happen here (might be macro)
macro logging*(levelIdent: untyped, args: varargs[untyped]): untyped =
    if not(levelIdent.kind == nnkDotExpr and levelIdent[0] == ident"LoggerLevel") and levelIdent.kind != nnkIdent:
        error "lol", levelIdent
    if args.len == 0:
        error "no args", args
    
    let statement = newNimNode nnkCall
    statement.add newIdentNode "logger"                  # [0]
    statement.add levelIdent                             # [1]
    statement.add newNimNode nnkCall                     # [2]
    statement[2].add newIdentNode "instantiationInfo"    # [2][0]

    for arg in args:
        case arg.kind
        of nnkStrLit:
            let objc = newNimNode nnkObjConstr
            objc.add newIdentNode "LoggerObj"    # [0]
            objc.add newNimNode nnkExprColonExpr # [1]
            objc[1].add newIdentNode "text"      # [1][0]
            objc[1].add arg                      # [1][1]

            statement.add objc
        else:
            error "Not support (yet)"

    result = newNimNode nnkStmtList
    result.add statement

    echo result.astGenRepr

# generic print func/macro/template/whatever.
template print*(args: varargs[untyped]) = logging PRINT, args

# write(stdout, "test stdout")
# write(stdout, "test again")

# dumpTree:
#     logger LoggerLevel.PRINT, instantiationInfo(), LoggerObj(text: "haha")


# expandMacros:
#     logging(LoggerLevel.PRINT, "haha")
