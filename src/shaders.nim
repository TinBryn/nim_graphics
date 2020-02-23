import nimgl/opengl


proc `$`(buf: openArray[char]): string =
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
  vertexSource* = readFile("../shaders/vertex.glsl")
  fragmentSource* = readFile("../shaders/fragment.glsl")

proc createShader*(vertex, fragment: string): GLuint =
  var
    vertexShader = glCreateShader(GLVertexShader)
    fragmentShader = glCreateShader(GlFragmentShader)
    program = glCreateProgram()
