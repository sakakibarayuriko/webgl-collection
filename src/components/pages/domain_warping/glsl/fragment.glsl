precision mediump float;
uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

float random (in vec2 st) {
  return fract(sin(dot(st.xy,vec2(12.9898,78.233)))*43758.5453123);
}

float noise (in vec2 st) {
  vec2 i = floor(st);
  vec2 f = fract(st);

  // 4つの2Dのタイル
  float a = random(i);
  float b = random(i + vec2(1.0, 0.0));
  float c = random(i + vec2(0.0, 1.0));
  float d = random(i + vec2(1.0, 1.0));

  vec2 u = f * f;

  return mix(a, b, u.x) + (c-a) * u.y * (1.0-u.x) + (d-b) * u.x * u.y;
}

#define NUM_OCTAVES 5

// 非整数ブラウン運動（周波数が増加し、振幅が減少するノイズ波の単純な合計）
float fbm(in vec2 st) {
  float v = 0.0;
  float a = 0.5;
  vec2 shift = vec2(100.0);

  // 回転して軸方向のバイアスを減らす
  mat2 rot = mat2(cos(0.5), sin(0.5), -sin(0.5), cos(0.5));
  for (int i = 0; i < NUM_OCTAVES; ++i) {
    v += a * noise(st);
    st = rot * st * 2.0 + shift;
    a *= 0.5;
  }
  return v;
}

void main() {
  vec2 st = gl_FragCoord.xy/resolution*5.0;
  vec3 color = vec3(0.0);

  vec2 q = vec2(0.0);
  q.x = fbm(st);
  q.y = fbm(st + vec2(1.0));

  vec2 r = vec2(0.0);
  r.x = fbm(st + q + vec2(1.7,9.2) + (time*0.2) + (mouse*0.2));
  r.y = fbm(st + q + vec2(8.3,2.8) + (time*0.2) + (mouse*0.2));

  float f = fbm(st+r);

  // 1色目
  color = mix(vec3(0.0,0.3,0.6),vec3(0.0,0.0,0.0),0.0);

  // 2色目
  color = mix(color,vec3(0.0,0.6,0.4),clamp(length(r.x),0.0,1.0));

  // 明るさ
  gl_FragColor = vec4((f*f*f+2.5*f*f+1.5*f)*color,1.0);
}