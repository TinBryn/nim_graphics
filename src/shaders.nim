import nimgl/opengl, tables, glm

type
  Shader* = object
    program: GLuint
    attributeLocations: Table[string, GLuint]
    uniformLocations: Table[string, GLuint]

proc use*(shader: Shader) =
  glUseProgram(shader.program)

proc `[]`*(shader: var Shader, attrib: string): GLuint =
  if attrib notin shader.attributeLocations:
    shader.attributeLocations[attrib] = glGetAttribLocation(shader.program, attrib).Gluint
  shader.attributeLocations[attrib]

proc `{}`*(shader: var Shader, uniform: string): GLuint =
  if uniform notin shader.uniformLocations:
    shader.uniformLocations[uniform] = glGetUniformLocation(shader.program, uniform).GLuint
  shader.uniformLocations[uniform]

proc `$$`(buf: openArray[char]): string {.used.} =
  for c in buf:
    result &= $c

proc compileShader(shader: GLuint, source: string) =
  var csource: cstring = source
  glShaderSource(shader, cast[GLsizei](1), addr csource, nil)
  glCompileShader(shader)
  var success: int32
  glGetShaderiv(shader, GL_COMPILE_STATUS, addr success)
  if success == 0:
    var infoLog: array[512, char]
    glGetShaderInfoLog(shader, 512, nil, addr infoLog[0])
    echo $$infoLog

template withShaders(program: GLuint, shaders: varargs[GLuint], body: untyped): untyped =
  let p = program
  try:
    for s in shaders:
      glAttachShader(p, s)
    body
  finally:
    for s in shaders:
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
  
  Shader(program: program, attributeLocations: initTable[string, GLuint]())

proc setUniform*(shader: var Shader, name: string, value: GLfloat) =
  let location = shader{name}.GLint
  glUniform1f(location, value)

proc `{}=`*[T](shader: var Shader, name: string, value: var T) =
  let location = shader{name}.GLint
  when T is GLfloat: glUniform1f(location, value)
  elif T is Vec3: glUniform3fv(location, 1, value.caddr)
  elif T is Vec4: glUniform4fv(location, 1, value.caddr)
  elif T is Mat4: glUniformMatrix4fv(location, 1, false, value.caddr)

{.experimental: "dotOperators".}

template `.=`*[T](shader: var Shader, uniform: untyped, value: var T) =
  shader.setUniform(astToStr(uniform), value)
