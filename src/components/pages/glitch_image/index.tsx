import { useEffect, useRef } from "react";
import * as THREE from "three";
import vertexShader from "./glsl/vertex.glsl";
import fragmentShader from "./glsl/fragment.glsl";
import shader from "utils/shader";

const GlitchImageContent: React.FC = () => {
  const $shader = useRef<HTMLDivElement>(null);
  const TEXTURE =
    "https://images.unsplash.com/photo-1533106497176-45ae19e68ba2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80";

  useEffect(() => {
    if (!$shader || $shader === null) return;

    shader(
      $shader.current!,
      vertexShader,
      fragmentShader,
      {
        uniforms: {
          texture: {
            value: new THREE.TextureLoader().load(TEXTURE),
          },
          time: {
            value: 0,
          },
          mouse: {
            value: new THREE.Vector2(0.0, 0.0),
          },
          resolution: {
            value: new THREE.Vector2(window.innerWidth, window.innerHeight),
          },
        },
      },
      true
    );
  }, []);
  return <div id="shader" ref={$shader}></div>;
};

export { GlitchImageContent };
