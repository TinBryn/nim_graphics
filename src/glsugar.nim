import nimgl/opengl

type GLtypes = GLfloat | GLint | GLshort | GLbyte | GLdouble | GLfixed

proc vertexAttribPointer*(
  index: GLuint, size: GLint, td: typedesc[GLtypes],
  normalized: GLboolean, stride: GLint, offset: int
) =
  let typeParam =
    when td is GLdouble: EGLdouble
    elif td is GLfloat: EGLfloat
    elif td is GLshort: EGLshort
    elif td is GLfixed: EGLfixed
    elif td is GLbyte: EGLbyte
    elif td is GLint: EGLint

  glVertexAttribPointer(index, size, typeParam, normalized, stride, cast[pointer](offset))
