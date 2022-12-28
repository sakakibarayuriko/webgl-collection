precision highp float;
uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

#define MAX_STEPS 400
#define MAX_DIST 100.
#define EPSILON 0.001
#define COL1 1.
#define COL2 2.
#define COL3 3.

mat2 rot(float a) {
  float s = sin(a), c = cos(a);
  return mat2(c, -s, s, c);
}
vec3 mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}
vec2 mod289(vec2 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}
vec3 permute(vec3 x) {
  return mod289(((x*34.0)+1.0)*x);
}
float snoise(vec2 v) {
  // Precompute values for skewed triangular grid
  const vec4 C = vec4(0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439);

  // First corner (x0)
  vec2 i  = floor(v + dot(v, C.yy));
  vec2 x0 = v - i + dot(i, C.xx);

  // Other two corners (x1, x2)
  vec2 i1 = vec2(0.0);
  i1 = (x0.x > x0.y)? vec2(1.0, 0.0):vec2(0.0, 1.0);
  vec2 x1 = x0.xy + C.xx - i1;
  vec2 x2 = x0.xy + C.zz;

  // Do some permutations to avoid
  // truncation effects in permutation
  i = mod289(i);
  vec3 p = permute(permute( i.y + vec3(0.0, i1.y, 1.0)) + i.x + vec3(0.0, i1.x, 1.0 ));

  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x1,x1), dot(x2,x2)), 0.0);

  m = m*m ;
  m = m*m ;

  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;

  // Normalise gradients implicitly by scaling m
  // Approximation of: m *= inversesqrt(a0*a0 + h*h);
  m *= 1.79284291400159 - 0.85373472095314 * (a0*a0+h*h);

  // Compute final noise value at P
  vec3 g = vec3(0.0);
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * vec2(x1.x,x2.x) + h.yz * vec2(x1.y,x2.y);
  return 130.0 * dot(m, g);
}

vec2 getDist(vec3 p) {
  p+=.03*snoise(p.yz*2.3*mouse);
  return vec2((length(p)-.5)*.8, COL1);
}

vec4 rayMarch(vec3 ro, vec3 rd) {
	float d = 0.;
  float info = 0.;
  float glow = 9999.;
  int ii=0;
  for (int i = 0; i < MAX_STEPS; i++) {
    ii=i;
  	vec2 distToClosest = getDist(ro + rd * d);
    d += abs(distToClosest.x);
    info = distToClosest.y;
    glow = min(glow, abs(distToClosest.x));
    if(abs(distToClosest.x) < EPSILON || d > MAX_DIST) {
    	break;
    }
  }
  return vec4(d, info, ii, glow);
}

vec3 getNormal(vec3 p) {
    vec2 e = vec2(EPSILON, 0.);
    vec3 n = getDist(p).x - vec3(getDist(p - e.xyy).x, getDist(p - e.yxy).x, getDist(p - e.yyx).x);
	return normalize(n);
}

vec3 getRayDir(vec2 uv, vec3 p, vec3 l, float z) {
  vec3 f = normalize(l-p),
    r = normalize(cross(vec3(0,1,0), f)),
    u = cross(f,r),
    c = f*z,
    i = c + uv.x*r + uv.y*u,
    d = normalize(i);
  return d;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = (fragCoord-.5*resolution.xy)/resolution.y;
  vec3 p, color,rd,n,ro,ref;
  vec4 rm;
  ro = vec3(0,0,1.5);
  ro.xz *= rot(time);
  float d, info, dtotal=0., steps, marches, glow;
  rd = getRayDir(uv, ro, vec3(0), 1.0);

  vec3 light = vec3(50, 50, 50);

  // making several marches outside and inside
  // the surface along the ray
  for (int i = 0; i < 5; i++) {
    rm = rayMarch(ro, rd);
    info = rm[1];
    glow += rm[3];
    dtotal += d = rm[0];
    if (dtotal > MAX_DIST) break;
    p = ro + rd * d;
    n = getNormal(p);
    float refK = 7.;
    ref = reflect(rd, n);
    //color += refK*texture(iChannel0, ref).xyz;
    //color += refK;
    marches += refK;
    color += 2.*smoothstep(-.5,1.,dot(ref, rd));
    color += 2.*smoothstep(.6,1.,dot(ref, rd));
    vec3 amp = vec3(1.5);
    n.z += amp.z*snoise(n.xy*.6+time*.05);
    n.x += amp.x*snoise(n.yz*.6+time*.05);
    n.y += amp.y*snoise(n.xz*.6+time*.05);
    color += n*.5+.5;
    marches++;
    ro = p + rd * 0.05;
  }
  color/=marches;

  fragColor = vec4(color,1);
}

void main() {
  vec4 col;
  mainImage(col, gl_FragCoord.xy);
  gl_FragColor = col;
}