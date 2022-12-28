import * as THREE from "three";

const shader = (
  $target: HTMLElement,
  vertexShader: string,
  fragmentShader: string,
  material: THREE.ShaderMaterialParameters,
  hasTexture?: boolean
) => {
  const scene = new THREE.Scene();
  const renderer = new THREE.WebGLRenderer();
  renderer.setSize(window.innerWidth, window.innerHeight);
  let camera;
  const generateCameraParam = (scale: number) => {
    const aspect = window.innerWidth / window.innerHeight;
    return {
      aspect: aspect,
      left: -aspect * scale,
      right: aspect * scale,
      top: scale,
      bottom: -scale,
    };
  };
  const cameraParam = generateCameraParam(2.0);
  if (hasTexture) {
    camera = new THREE.OrthographicCamera(
      cameraParam.left,
      cameraParam.right,
      cameraParam.top,
      cameraParam.bottom,
      0.0,
      20.0
    );
    camera.position.set(0, 0, 10);
  } else {
    camera = new THREE.PerspectiveCamera(
      0,
      window.innerWidth / window.innerHeight,
      0.1,
      0
    );
  }
  const shaderMaterial = new THREE.RawShaderMaterial({
    uniforms: material.uniforms,
    vertexShader,
    fragmentShader,
  });
  const geometry = new THREE.PlaneGeometry(2.0, 2.0);
  const mesh = new THREE.Mesh(geometry, shaderMaterial);
  if (hasTexture) {
    mesh.scale.set(cameraParam.right * 2, cameraParam.top * 2, 1);
  }
  const clock = new THREE.Clock();
  $target.appendChild(renderer.domElement);

  const init = () => {
    scene.add(mesh);
    clock.start();
    window.addEventListener("resize", resize);
  };

  const loop = () => {
    render();
    requestAnimationFrame(loop);
  };

  const render = () => {
    material.uniforms.time.value = clock.getElapsedTime();
    renderer.render(scene, camera);
  };

  const resize = () => {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(window.innerWidth, window.innerHeight);
    material.uniforms.resolution.value.set(
      window.innerWidth,
      window.innerHeight
    );
  };

  window.addEventListener("mousemove", (e) => {
    material.uniforms.mouse.value.x =
      (e.clientX - window.innerWidth / 2.0) / (window.innerWidth / 2.0);
    material.uniforms.mouse.value.y =
      -(e.clientY - window.innerHeight / 2.0) / (window.innerHeight / 2.0);
  });

  init();
  loop();
};

export default shader;
