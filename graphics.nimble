# Package

version       = "0.1.0"
author        = "Kieran"
description   = "Some graphics in nim"
license       = "MIT"
binDir        = "bin"
srcDir        = "src"
bin           = @["graphics"]



# Dependencies

requires "nim >= 1.0.0", "nimgl >= 1.1.1"

# Tasks

task debug, "":
  exec "nim c --outdir:debug --lineDir:on --debuginfo:on --debugger:native src/graphics.nim"

task build, "":
  exec "nim c --ourdir:bin src/graphics.nim"
