import nimgl/[glfw,opengl], glm, shaders

var triangle = [
  vec3f(-0.5, -0.5, 0.0),
  vec3f(0.5, -0.5, 0.0),
  vec3f(0.0, 0.5, 0.0)
]

if not glfwInit():
  quit("GLFW initialisation failed")

let window = glfwCreateWindow(800, 600, "Window", nil, nil, false)
window.makeContextCurrent()
assert glInit()
glClearColor(0.2f, 0.3f, 0.4f, 1.0f)

var vbo: uint32
glGenBuffers(1, addr vbo)

glBindBuffer(GL_ARRAY_BUFFER, vbo)
glBufferData(GL_ARRAY_BUFFER, sizeof triangle, addr triangle[0], GL_STATIC_DRAW)

while not window.windowShouldClose():
  glfwPollEvents()
  glClear(GL_COLOR_BUFFER_BIT)
  window.swapBuffers()
