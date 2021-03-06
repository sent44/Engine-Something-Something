import std/strutils

## Configurations
put "binName", "engine"
put "debug", "no"
put "enableTypeN", "yes"

# Should not config these
switch "import", "src/backend/enginefunc"
switch "threads", "on"
switch "showAllMismatches", "on"
switch "path", "src/"
# switch "define", "nimPreviewSlimSystem"


var disableConfigHint = true
var outBin = false
var enableMWindow = false
var importLogging = true
var debug = true

## Tasks
task beforeBuild, "":
    enableMWindow = true
    debug = false
    switch "dynlibOverride", "libSDL2"
    switch "passL", "-static -lmingw32 -lSDL2main -lSDL2 -Wl,--no-undefined -Wl,--dynamicbase -Wl,--nxcompat -Wl,--high-entropy-va -lm -ldinput8 -ldxguid -ldxerr8 -luser32 -lgdi32 -lwinmm -limm32 -lole32 -loleaut32 -lshell32 -lsetupapi -lversion -luuid"
    
    for i in 2 ..< paramCount() + 1:
        var args = paramStr(i).split("=")
        if args.len == 2:
            put args[0], args[1]
        else:
            raise newException(CatchableError, "NO")
    
    if get("debug") == "yes":
        debug = true


    disableConfigHint = false
    outBin = true

task build, "Build the project!":
    beforeBuildTask()
    setCommand "compile", "src/main.nim"

task run, "Build and run!":
    beforeBuildTask()
    # put "debug", "yes"
    switch "run"
    setCommand "compile", "src/main.nim"

task tests, "Run the unit testing":
    exec "testament category /"

task help, """
Print help below!
=================================
debug=yes/no [default: """ & get("debug") & """]
enableTypeN=yes/no [default: """ & get("enableTypeN") & """]

this is help
very helpful help!
""": discard

# VSCode tasks
task vscodeBuildCurrentFile, "":
    beforeBuildTask()
    if not exists("file"):
        raise newException(CatchableError, "NO")
    
    var filePath = get("file").rsplit("/", 1)
    if filePath.len == 1:
        filePath = get("file").rsplit("\\", 1)
    
    var folderPath = get("file").split("/", 1)
    if folderPath.len == 1:
        folderPath = get("file").split("\\", 1)

    var fileName = filePath[0]
    if filePath.len > 1:
        fileName = filePath[1]
    
    var fileExt = fileName.rsplit(".", 1)
    if fileExt[0] == "main":
        switch "hints", "off"
        echo "VSCode (auto) build task for `main.nim` is disabled."
    elif fileExt.len == 2 and fileExt[1] == "nim":
        if folderPath[0] == "tests":
            importLogging = false
        switch "hints", "off"
        outBin = false
        setCommand "r", get "file"

task vscodeBuildDebug, "":
    beforeBuildTask()


## Conditional configurations

# Both NimScript and anything in tests/ are angry at import `Logging` for some reason
# While NimScript error is not really a problem, tests/ script is
if not defined(testing) and importLogging:
    switch "import", "src/backend/logging"

# `-mwindows` is making print log disappear :(
if debug or defined(debug):
    if enableMWindow:
        switch "passL", "-mwindows"
else:
    # Might be able to pass `--define:debug` in command instant of `debug=yes`
    # So if `debug=yes` but not `--define:debug` then set it
    if not defined(debug):
        switch "define", "debug"

if get("enableTypeN") == "yes":
    if not defined(typeN):
        switch "define", "typeN"

# Sometimes these hints are annoy
if disableConfigHint:
    switch "hint", "Conf:off"

# Either not need (VSCode build current file task) or can't (testament)
if outBin:
    switch "out", "bin/" & get("binName")
