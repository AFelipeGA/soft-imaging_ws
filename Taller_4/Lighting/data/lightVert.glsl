uniform mat4 modelviewMatrix;
uniform mat4 transformMatrix;
uniform mat3 normalMatrix;
uniform mat4 texMatrix;

attribute vec4 ambient;
attribute vec4 specular;
attribute vec4 emissive;
attribute float shininess;

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;
attribute vec2 texCoord;

varying vec3 ecNormal;
varying vec3 ecVertex;
varying vec3 ecNormalInv;
varying vec4 vertTexCoord;

varying vec4 vertColor;
varying vec4 vertAmbient;
varying vec4 vertSpecular;
varying vec4 vertEmissive;
varying float vertShininess;

const float zero_float = 0.0;
const float one_float = 1.0;
const vec3 zero_vec3 = vec3(0);


void main() {
  // Vertex in clip coordinates
  gl_Position = transformMatrix * position;
    
  // Vertex in eye coordinates
  ecVertex = vec3(modelviewMatrix * position);
  
  // Normal vector in eye coordinates
  ecNormal = normalize(normalMatrix * normal);
  ecNormalInv = ecNormal * -one_float;
                  
  // Calculating texture coordinates, with r and q set both to one
  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);        

  vertColor = color;
  vertAmbient = ambient;
  vertSpecular = specular;
  vertEmissive = emissive;
  vertShininess = shininess;
}