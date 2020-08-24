const
  fragmentFile = "shaders/fragment.glsl"
  vertexFile = "shaders/vertex.glsl"

let
  vertexSource* = readFile(vertexFile)
  fragmentSource* = readFile(fragmentFile)

type Colours = enum
  orange,
  green,
  blue,
  pink,

import glm

const pallette: array[Colours, Vec3f] = [
  vec3f(0.8, 0.4, 0.1),
  vec3f(0.1, 0.8, 0.1),
  vec3f(0.1, 0.4, 0.8),
  vec3f(0.8, 0.1, 0.8)
]

const square* = [[
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