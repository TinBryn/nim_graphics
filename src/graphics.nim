import nimgl/[glfw,opengl], glm, shaders, glsugar, callbacks, constants, math

proc main =
  # let triangle = [
  #   vec3f(-0.5, -0.5, 0.0),
  #   vec3f(0.5, -0.5, 0.0),
  #   vec3f(0.0, 0.5, 0.0)
  # ]

  type Colours = enum
    orange,
    green,
    blue,
    pink,

  var res: array[Colours, Vec3f]
  res[orange] = vec3f(0.8, 0.4, 0.1)
  res[green] = vec3f(0.1, 0.8, 0.1)
  res[blue] = vec3f(0.1, 0.4, 0.8)
  res[pink] = vec3f(0.8, 0.1, 0.8)

  let pallette = res

  let square = [[
    vec3f(-0.5, -0.5, 0.0),
    vec3f(0.5, -0.5, 0.0),
    vec3f(0.5, 0.5, 0.0),
    vec3f(-0.5, 0.5, 0.0),
    vec3f(-0.5, -0.5, 0.0),
    vec3f(0.5, 0.5, 0.0)
  ],[
    pallette[blue],
    pallette[green],
    pallette[orange],
    pallette[pink],
    pallette[blue],
    pallette[orange]
  ]]

  var shape = square[0]
  var colours = square[1]

  if not glfwInit():
    quit("GLFW initialisation failed")

  glfwWindowHint(GLFWContextVersionMajor, 3)
  glfwWindowHint(GLFWContextVersionMinor, 3)
  glfwWindowHint(GLFWOpenglProfile, GLFWOpenglCoreProfile)

  let window = glfwCreateWindow(800, 600, "Window", nil, nil, false)
  glfwSwapInterval(1)
  setupCallbacks(window)
  window.makeContextCurrent()
  assert glInit()
  glClearColor(0.2f, 0.3f, 0.4f, 1.0f)

  var shader = createShader(vertexSource, fragmentSource)

  let location_aPos = shader["aPos"]
  let location_aCol = shader["aCol"]

  shader.use()

  const
    nVAOs = 1
    nVBOs = 2

  var
    vao: array[nVAOs, uint32]
    vbo: array[nVBOs, uint32]
  glGenVertexArrays(nVAOs, addr vao[0])
  glGenBuffers(nVBOs, addr vbo[0])

  glBindVertexArray(vao[0])
  glBindBuffer(GL_ARRAY_BUFFER, vbo[0])
  glBufferData(GL_ARRAY_BUFFER, sizeof shape, addr shape[0], GL_STATIC_DRAW)

  vertexAttribPointer(location_aPos, 3, GLfloat, false, 3 * sizeof(GLfloat), 0)
  glEnableVertexAttribArray(location_aPos)

  glBindBuffer(GL_ARRAY_BUFFER, vbo[1])
  glBufferData(GL_ARRAY_BUFFER, sizeof colours, addr colours[0], GL_STATIC_DRAW)

  vertexAttribPointer(location_aCol, 3, GLfloat, false, 3 * sizeof(GLfloat), 0)
  glEnableVertexAttribArray(location_aCol)

  glPolygonMode(GLFrontAndBack, GLFill)

  var shift = 0f
  ## the old colour I was using `vec3f(1.0, 0.5, 0.2)`

  while not window.windowShouldClose():
    glfwPollEvents()
    glClear(GL_COLOR_BUFFER_BIT)
    shader.shift = shift
    shift += 1/32f
    if shift >= 2*PI:
      shift -= 2*PI
    glDrawArrays(GLTriangles, 0, shape.len.GLsizei)
    window.swapBuffers()

when isMainModule:
  main()
