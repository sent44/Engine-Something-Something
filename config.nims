switch("import", "src/enginefunc")
switch("warning", "UnusedImport:off")
switch("dynlibOverride", "libSDL2")
switch("passL", "-static -lmingw32 -lSDL2main -lSDL2 -Wl,--no-undefined -Wl,--dynamicbase -Wl,--nxcompat -Wl,--high-entropy-va -lm -ldinput8 -ldxguid -ldxerr8 -luser32 -lgdi32 -lwinmm -limm32 -lole32 -loleaut32 -lshell32 -lsetupapi -lversion -luuid")

if not defined(debug):
    switch("passL", "-mwindows")
