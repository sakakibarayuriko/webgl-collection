precision mediump float;
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float random (vec2 st) {
  return fract(sin(dot(st.xy, vec2(12.9898,78.233)))* 43758.5453123);
}

vec3 noise(vec2 p) {
  vec3 p3 = vec3(p + random(p) - 1.0, 0.1);

  for (int i = 0; i < 50; i++) {
    p3.xzy = abs(((p3) / dot(p3, p3) - vec3(1.0, 1.0, mouse * 0.5)));
  }

  return p3.xzy;
}

void main() {
  vec2 p = gl_FragCoord.xy / resolution;

  // ノイズ
  vec3 d = noise(p);
  d *= dot(d, d);

  // グラデーション
  vec3 v = fract(vec3(p.x, 0.0, p.y));

  for (int i = 0; i < 50; i++) {
    v = fract(v + d);
  }

  gl_FragColor = vec4(v, 1.0);
}
