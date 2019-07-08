uniform mat4 modelviewMatrix;
uniform mat4 transformMatrix;
uniform mat3 normalMatrix;
uniform mat4 texMatrix;

uniform int myLightCount;
uniform vec4 myLightPosition[10];
uniform vec3 myLightNormal[10];
uniform vec3 myLightAmbient[10];
uniform vec3 myLightDiffuse[10];
uniform vec3 myLightSpecular[10];      
uniform vec3 myLightFalloff[10];
uniform vec2 myLightSpot[10];

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;
attribute vec2 texCoord;

attribute vec4 ambient;
attribute vec4 specular;
attribute vec4 emissive;
attribute float shininess;

varying vec4 vertColor;
varying vec4 backVertColor;
varying vec4 vertTexCoord;

const float zero_float = 0.0;
const float one_float = 1.0;
const vec3 zero_vec3 = vec3(0);

float falloffFactor(vec3 lightPos, vec3 vertPos, vec3 coeff) {
  vec3 lpv = lightPos - vertPos;
  vec3 dist = vec3(one_float);
  dist.z = dot(lpv, lpv);
  dist.y = sqrt(dist.z);
  return one_float / dot(dist, coeff);
}

float spotFactor(vec3 lightPos, vec3 vertPos, vec3 lightNorm, float minCos, float spotExp) {
  vec3 lpv = normalize(lightPos - vertPos);
  vec3 nln = -one_float * lightNorm;
  float spotCos = dot(nln, lpv);
  return spotCos <= minCos ? zero_float : pow(spotCos, spotExp);
}

float lambertFactor(vec3 lightDir, vec3 vecNormal) {
  return max(zero_float, dot(lightDir, vecNormal));
}

float blinnPhongFactor(vec3 lightDir, vec3 vertPos, vec3 vecNormal, float shine) {
  vec3 np = normalize(vertPos);
  vec3 ldp = normalize(lightDir - np);
  return pow(max(zero_float, dot(ldp, vecNormal)), shine);
}

void main() {
  // Vertex in clip coordinates
  gl_Position = transformMatrix * position;
    
  // Vertex in eye coordinates
  vec3 ecVertex = vec3(modelviewMatrix * position);
  
  // Normal vector in eye coordinates
  vec3 ecNormal = normalize(normalMatrix * normal);
  vec3 ecNormalInv = ecNormal * -one_float;
  
  // Light calculations
  vec3 totalAmbient = vec3(0, 0, 0);
  
  vec3 totalFrontDiffuse = vec3(0, 0, 0);
  vec3 totalFrontSpecular = vec3(0, 0, 0);
  
  vec3 totalBackDiffuse = vec3(0, 0, 0);
  vec3 totalBackSpecular = vec3(0, 0, 0);
  
  for (int i = 0; i < 10; i++) {
    if (myLightCount == i) break;
    
    vec3 lightPos = myLightPosition[i].xyz;
    bool isDir = myLightPosition[i].w < one_float;
    float spotCos = myLightSpot[i].x;
    float spotExp = myLightSpot[i].y;
    
    vec3 lightDir;
    float falloff;    
    float spotf;
      
    if (isDir) {
      falloff = one_float;
      lightDir = -one_float * myLightNormal[i];
    } else {
      falloff = falloffFactor(lightPos, ecVertex, myLightFalloff[i]);  
      lightDir = normalize(lightPos - ecVertex);
    }
  
    spotf = spotExp > zero_float ? spotFactor(lightPos, ecVertex, myLightNormal[i], 
                                              spotCos, spotExp) 
                                 : one_float;
    
    if (any(greaterThan(myLightAmbient[i], zero_vec3))) {
      totalAmbient       += myLightAmbient[i] * falloff;
    }
    
    if (any(greaterThan(myLightDiffuse[i], zero_vec3))) {
      totalFrontDiffuse  += myLightDiffuse[i] * falloff * spotf * 
                            lambertFactor(lightDir, ecNormal);
      totalBackDiffuse   += myLightDiffuse[i] * falloff * spotf * 
                            lambertFactor(lightDir, ecNormalInv);
    }
    
    if (any(greaterThan(myLightSpecular[i], zero_vec3))) {
      totalFrontSpecular += myLightSpecular[i] * falloff * spotf * 
                            blinnPhongFactor(lightDir, ecVertex, ecNormal, shininess);
      totalBackSpecular  += myLightSpecular[i] * falloff * spotf * 
                            blinnPhongFactor(lightDir, ecVertex, ecNormalInv, shininess);
    }     
  }    
  
  // Calculating final color as result of all lights (plus emissive term).
  // Transparency is determined exclusively by the diffuse component.
  vertColor =     vec4(totalAmbient, 0) * ambient + 
                  vec4(totalFrontDiffuse, 1) * color + 
                  vec4(totalFrontSpecular, 0) * specular + 
                  vec4(emissive.rgb, 0);
              
  backVertColor = vec4(totalAmbient, 0) * ambient + 
                  vec4(totalBackDiffuse, 1) * color + 
                  vec4(totalBackSpecular, 0) * specular + 
                  vec4(emissive.rgb, 0);
                  
  // Calculating texture coordinates, with r and q set both to one
  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);        
}