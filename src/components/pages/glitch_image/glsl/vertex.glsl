attribute vec3 position;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
attribute vec2 uv;
varying vec2 vUv;

void main(void) {
  vUv = uv;
  gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
}
