#version 330 core

uniform float shift;

in vec3 vCol;

out vec4 FragColor;

vec3 shiftHue(vec3 input, float shift)
{
  float u = cos(shift);
  float w = sin(shift);

  vec3 ret;
  ret.r = (0.299 + 0.701*u + 0.168*w) * input.r
        + (0.587 - 0.587*u + 0.330*w) * input.g
        + (0.114 - 0.114*u - 0.497*w) * input.b;
  
  ret.g = (0.299 - 0.299*u - 0.328*w) * input.r
        + (0.587 + 0.413*u + 0.035*w) * input.g
        + (0.114 - 0.114*u + 0.292*w) * input.b;
  
  ret.b = (0.299 - 0.300*u + 1.250*w) * input.r
        + (0.587 - 0.580*u - 1.050*w) * input.g
        + (0.114 + 0.886*u - 0.203*w) * input.b;
  return ret;
}

void main()
{
  FragColor = vec4(shiftHue(vCol, shift), 1.0);
}
