import nimgl/[glfw,opengl], glm, shaders, glsugar, callbacks

proc main =
  var triangle = [
    vec3f(-0.5, -0.5, 0.0),
    vec3f(0.5, -0.5, 0.0),
    vec3f(0.0, 0.5, 0.0)
  ]

  if not glfwInit():
    quit("GLFW initialisation failed")

  let window = glfwCreateWindow(800, 600, "Window", nil, nil, false)
  setupCallbacks(window)
  window.makeContextCurrent()
  assert glInit()
  glClearColor(0.2f, 0.3f, 0.4f, 1.0f)

  var shader = createShader(vertexSource, fragmentSource)

  let location_aPos = shader["aPos"]

  shader.use()

  const
    nVAOs = 1
    nVBOs = 1

  var
    vao: array[nVAOs, uint32]
    vbo: array[nVBOs, uint32]
  glGenVertexArrays(nVAOs, addr vao[0])
  glGenBuffers(nVBOs, addr vbo[0])

  glBindVertexArray(vao[0])
  glBindBuffer(GL_ARRAY_BUFFER, vbo[0])
  glBufferData(GL_ARRAY_BUFFER, sizeof triangle, addr triangle[0], GL_STATIC_DRAW)

  vertexAttribPointer(location_aPos, 3, GLfloat, false, 3 * sizeof(GLfloat), 0)
  glEnableVertexAttribArray(location_aPos)

  glPolygonMode(GLFrontAndBack, GLLine)

  while not window.windowShouldClose():
    glfwPollEvents()
    glClear(GL_COLOR_BUFFER_BIT)
    glDrawArrays(GLTriangles, 0, triangle.len.GLsizei)
    window.swapBuffers()

when isMainModule:
  main()
