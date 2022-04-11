# Package

version          = "0.1.0"
author           = "sent44"
description      = "A new awesome nimble (not) package"
#license         = "GPL-3.0-or-later"
license          = "Not yet select or write one yet!"
srcDir           = "src"
# bin            = @["main"]
binDir           = "bin"
namedBin["main"] = "engine" 


# Dependencies

requires "nim >= 1.6.4"
requires "sdl2 >= 2.0.3"

before build:
    echo "Use `nim build` to pass build option."

task test, "": # Override default nimble test task
    exec "nim tests"

#include "config.nims"
