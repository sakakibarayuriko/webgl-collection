precision mediump float;
uniform float time;
uniform vec2 resolution;

void main(void){
	vec3 destColor = vec3(sin(time), 0.2, 0.6);

	//原点を中央にする
	vec2 p = (gl_FragCoord.xy*2.0-resolution) / min(resolution.x,resolution.y);
	float size = 13.0;
	float speed = -5.0*time;

	//原点から一定の距離にある場所ほど小さい値になる（光る）ようにする
	float dist = 1.0;
	float t = 0.1 / abs(sin(size*length(p) + speed) - dist);

	gl_FragColor = vec4(t*destColor, 1.0);
}
