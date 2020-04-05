import nimgl/opengl, tables

type
  Shader* = object
    program: GLuint
    locations: Table[string, GLuint]

proc use*(shader: Shader) =
  glUseProgram(shader.program)

proc `[]`*(shader: var Shader, attrib: string): GLuint =
  if attrib notin shader.locations:
    shader.locations[attrib] = glGetAttribLocation(shader.program, attrib).Gluint
  shader.locations[attrib]

proc `$`(buf: openArray[char]): string {.used.} =
  for c in buf:
    result &= c

proc compileShader(shader: GLuint, source: string) =
  var csource: cstring = source
  glShaderSource(shader, cast[GLsizei](1), addr csource, nil)
  glCompileShader(shader)
  var success: int32
  glGetShaderiv(shader, GL_COMPILE_STATUS, addr success)
  if success == 0:
    var infoLog: array[512, char]
    glGetShaderInfoLog(shader, 512, nil, addr infoLog[0])
    echo infoLog

const
  vertexSource* = readFile("shaders/vertex.glsl")
  fragmentSource* = readFile("shaders/fragment.glsl")

template debug(message: varargs[untyped, `$`]) =
  when not defined(release):
    debugEcho(message)

template withShaders(program: GLuint, shaders: varargs[GLuint], body: untyped): untyped =
  let p = program
  try:
    for s in shaders:
      debug "attaching shader"
      glAttachShader(p, s)
    body
  finally:
    for s in shaders:
      debug "detaching shader"
      glDetachShader(p, s)
      glDeleteShader(s)

proc createShader*(vertex, fragment: string): Shader =
  var
    vertexShader = glCreateShader(GLVertexShader)
    fragmentShader = glCreateShader(GlFragmentShader)
    program = glCreateProgram()
  
  vertexShader.compileShader(vertex)
  fragmentShader.compileShader(fragment)

  program.withShaders(vertexShader, fragmentShader):
    glLinkProgram(program)
  
  Shader(program: program, locations: initTable[string, GLuint]())
