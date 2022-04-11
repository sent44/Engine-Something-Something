import std/strutils

# Configs
switch "import", "src/enginefunc"
switch "dynlibOverride", "libSDL2"
switch "passL", "-static -lmingw32 -lSDL2main -lSDL2 -Wl,--no-undefined -Wl,--dynamicbase -Wl,--nxcompat -Wl,--high-entropy-va -lm -ldinput8 -ldxguid -ldxerr8 -luser32 -lgdi32 -lwinmm -limm32 -lole32 -loleaut32 -lshell32 -lsetupapi -lversion -luuid"

put "binName", "engine"

put "enableTypeN", "yes"
var disableConfigHint = true


# Tasks
task beforeBuild, "":
    for i in 2 ..< paramCount() + 1:
        var args = paramStr(i).split("=")
        if args.len == 2:
            put args[0], args[1]
        else:
            raise newException(CatchableError, "NO")
    disableConfigHint = false

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
debug=yes/no [default: no]
enableTypeN=yes/no [default: yes]

this is help
very helpful help!
""": discard

task vscodeBuildCurrentFile, "":
    beforeBuildTask()
    if not exists("file"):
        raise newException(CatchableError, "NO")
    var filePath = get("file").rsplit("/", 1)
    if filePath.len == 1:
        filePath = get("file").rsplit("\\", 1)
    var fileName = filePath[0]
    if filePath.len > 1:
        fileName = filePath[1]
    var fileExt = fileName.rsplit(".", 1)
    if fileExt.len == 2 and fileExt[1] == "nim":
        switch "run"
        switch "hints", "off"
        switch "path", "src/"
        put "binName", fileExt[0]
        setCommand "compile", get "file"

task vscodeBuildDebug, "":
    beforeBuildTask()

# Conditional configs
if not(exists("debug") and get("debug") == "yes"):
    switch "passL", "-mwindows"
else:
    if not defined(debug):
        switch "define", "debug"

if get("enableTypeN") == "yes":
    if not defined(typeN):
        switch "define", "typeN"

if disableConfigHint:
    switch "hint", "Conf:off"

switch "out", "bin/" & get("binName")
