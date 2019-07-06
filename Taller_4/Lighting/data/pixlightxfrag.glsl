#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;

varying vec4 vertColor;
varying vec3 lightDir;
varying vec4 vertTexCoord;
varying vec3 ecNormal;

void main() {
  vec3 direction = normalize(lightDir);
  vec3 normal = normalize(ecNormal);
  float intensity = max(0.3, dot(direction, normal));
  vec4 tintColor = vec4(intensity, intensity, intensity, 1) * vertColor;
  /* int si = int(vertTexCoord.s * 50.0);
  int sj = int(vertTexCoord.t * 50.0);
  gl_FragColor = texture2D(texture, vec2(float(si) / 50.0, float(sj) / 50.0)) * vertColor; */
  gl_FragColor = texture2D(texture, vertTexCoord.st) * tintColor;
}