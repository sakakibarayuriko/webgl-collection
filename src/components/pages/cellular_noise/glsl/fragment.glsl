precision mediump float;
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main() {
  // 左下をvec2(0,0)に正規化
  vec2 st = gl_FragCoord.xy/resolution;
  //st.x *= resolution.x/resolution.y;

  vec3 color = vec3(0.0);

  vec2 point[10];
  point[0] = vec2(0.83,0.75);
  point[1] = vec2(0.60,0.07);
  point[2] = vec2(0.28,0.64);
  point[3] = vec2(0.31,0.26);
  point[4] = vec2(0.93,0.15);
  point[5] = vec2(0.48,0.65);
  point[6] = vec2(0.38,0.85);
  point[7] = vec2(0.90,0.67);
  point[8] = vec2(0.10,0.10);
  point[9] = mouse;

  float minDist = 1.0;
  vec2 minPoint;

  for (int i = 0; i < 10; i++) {
    // 各ピクセルについて、最も近い点までの距離を算出する
    float dist = distance(st, point[i]);
    if (dist < minDist) {
      // より近い距離を代入
      minDist = dist;

      // より近いポイントの位置を代入
      minPoint = point[i];
    }
  }

  // 最も近い点への距離を追加
  color += minDist*3.0;

  // 最も近い点での色合いを代入
  color.rg = minPoint;

  gl_FragColor = vec4(color,1.0);
}