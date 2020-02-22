import nimgl/glfw, nimgl/opengl

if not glfwInit():
  quit("GLFW initialisation failed")

let window = glfwCreateWindow(800, 600, "Window", nil, nil, false)
window.makeContextCurrent()
assert glInit()
glClearColor(0.2f, 0.3f, 0.4f, 1.0f)

while not window.windowShouldClose():
  glfwPollEvents()
  glClear(GL_COLOR_BUFFER_BIT)
  window.swapBuffers()
