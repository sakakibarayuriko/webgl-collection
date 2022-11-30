import { useEffect, useRef } from "react";
import * as THREE from "three";

const GlitchImageContent: React.FC = () => {
  const mountRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const mountElment = mountRef.current;
    const width = window.innerWidth;
    const height = window.innerHeight;
    const TEXTURE =
      "https://images.unsplash.com/photo-1533106497176-45ae19e68ba2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80";
    const renderer = new THREE.WebGLRenderer();
    const scene = new THREE.Scene();

    const generateCameraParam = (scale: number) => {
      const aspect = width / height;
      return {
        aspect: aspect,
        left: -aspect * scale,
        right: aspect * scale,
        top: scale,
        bottom: -scale,
      };
    };
    const cameraParam = generateCameraParam(2.0);
    const camera = new THREE.OrthographicCamera(
      cameraParam.left,
      cameraParam.right,
      cameraParam.top,
      cameraParam.bottom,
      0.0,
      20.0
    );
    mountElment?.appendChild(renderer.domElement);
    renderer.setPixelRatio(window.devicePixelRatio);
    renderer.setSize(width, height);
    camera.position.set(0, 0, 10);

    const loader = new THREE.TextureLoader();
    const uTex = loader.load(TEXTURE, () => {
      render();
    });
    const clock = new THREE.Clock();
    const uTime = 0.0;
    let uMouse = new THREE.Vector2(0.0, 0.0);

    const vertex = `
      attribute vec3 position;
      uniform mat4 modelViewMatrix;
      uniform mat4 projectionMatrix;
      attribute vec2 uv;
      varying vec2 vUv;

      void main(void) {
        vUv = uv;
        gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
      }
    `;

    const fragment = `
      precision mediump float;
      varying vec2 vUv;
      uniform sampler2D uTex;
      uniform float uTime;
      uniform vec2 uMouse;

      float random (vec2 st) {
          return fract(sin(dot(st.xy, vec2(12.9898,78.233)))* 43758.5453123);
      }

      void main(){
        vec2 u = vUv;
        float r = random(vec2(u.y * .001, mod(uTime * 40.0 * uMouse.x, 40.0 * uMouse.y)));
        vec3 outCol = texture2D(uTex, u).rgb;

        if (r < 0.1) {
          outCol.r = texture2D(uTex, u + vec2(0.01, 0.0)).r;
        } else if (r < 0.2) {
          outCol.g = texture2D(uTex, u + vec2(0.01, 0.0)).g;
        } else {
          outCol.b = texture2D(uTex, u + vec2(0.01, 0.0)).b;
        }
        gl_FragColor = vec4(outCol, 1.0);
      }
    `;

    const material = new THREE.RawShaderMaterial({
      uniforms: {
        uTex: {
          value: uTex,
        },
        uTime: {
          value: uTime,
        },
        uMouse: {
          value: uMouse,
        },
      },
      vertexShader: vertex,
      fragmentShader: fragment,
    });
    const geometry = new THREE.PlaneGeometry(1, 1);
    const mesh = new THREE.Mesh(geometry, material);
    mesh.scale.set(cameraParam.right * 2, cameraParam.top * 2, 1);
    scene.add(mesh);

    const render = () => {
      mesh.material.uniforms.uTime.value += clock.getDelta();
      renderer.render(scene, camera);
    };

    const tick = () => {
      requestAnimationFrame(tick);
      render();
    };

    tick();

    window.addEventListener("mousemove", (e) => {
      uMouse.x = (e.clientX - width / 2.0) / (width / 2.0);
      uMouse.y = -(e.clientY - height / 2.0) / (height / 2.0);
    });

    return () => {
      mountElment?.removeChild(renderer.domElement);
    };
  }, []);

  return <div ref={mountRef} />;
};

export { GlitchImageContent };
