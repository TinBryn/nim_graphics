const
  fragmentFile = "shaders/fragment.glsl"
  vertexFile = "shaders/vertex.glsl"

let
  vertexSource* = readFile(vertexFile)
  fragmentSource* = readFile(fragmentFile)
