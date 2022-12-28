precision mediump float;
uniform float time;
uniform vec2 resolution;

#define PI 3.14159265358979

void main(void) {
  vec3 destColor = vec3(0.0, 0.04, 0.05);
	float ang = 0.0;
	vec3 c = vec3(0.0);
	float size = 1.0;
	vec2 p = (gl_FragCoord.xy*2.0-resolution) / min(resolution.x,resolution.y);

	for(float i=1.0; i<=6.0; i++){
		ang += PI / i;
    //動きバラバラにするためにsin(time+ang/0.5)する
		c += size / length(p - vec2(cos(ang),sin(ang))*0.5*sin(time+ang/0.5));
	}

	gl_FragColor = vec4(c*destColor, 1.0);
}
