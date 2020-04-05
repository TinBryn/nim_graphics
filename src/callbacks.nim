import nimgl/glfw

proc setupCallbacks*(window: GLFWWindow) =
  proc keyboard(window: GLFWwindow, key, code, action, mods: int32) {.cdecl.} =
    if glfw.toGLFWKey(key) == GLFWKey.ESCAPE:
      window.setWindowShouldClose(true)
  discard setKeyCallback(window, keyboard)
