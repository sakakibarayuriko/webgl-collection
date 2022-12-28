precision mediump float;
varying vec2 vUv;
uniform sampler2D texture;
uniform float time;
uniform vec2 mouse;

float random (vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233)))* 43758.5453123);
}

void main(){
  vec2 u = vUv;
  float r = random(vec2(u.y * .001, mod(time * 40.0 * mouse.x, 40.0 * mouse.y)));
  vec3 outCol = texture2D(texture, u).rgb;

  if (r < 0.1) {
    outCol.r = texture2D(texture, u + vec2(0.01, 0.0)).r;
  } else if (r < 0.2) {
    outCol.g = texture2D(texture, u + vec2(0.01, 0.0)).g;
  } else {
    outCol.b = texture2D(texture, u + vec2(0.01, 0.0)).b;
  }
  gl_FragColor = vec4(outCol, 1.0);
}
