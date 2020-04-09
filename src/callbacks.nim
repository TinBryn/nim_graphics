import nimgl/[glfw, opengl]

proc setupCallbacks*(window: GLFWWindow) =
  proc keyboard(window: GLFWwindow, key, code, action, mods: int32) {.cdecl.} =
    if glfw.toGLFWKey(key) == GLFWKey.ESCAPE:
      window.setWindowShouldClose(true)

  proc resize(window: GLFWwindow, width, height: int32) {.cdecl.} =
    glViewPort(0, 0, width, height)

  discard setKeyCallback(window, keyboard)
  discard setWindowSizeCallback(window, resize)
