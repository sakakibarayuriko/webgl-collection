import React, { useEffect, useRef } from "react";
import * as THREE from "three";
import vertexShader from "./glsl/vertex.glsl";
import fragmentShader from "./glsl/fragment.glsl";
import shader from "utils/shader";

const BubbleContent: React.FC = () => {
  const $shader = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!$shader || $shader === null) return;

    shader($shader.current!, vertexShader, fragmentShader, {
      uniforms: {
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
    });
  }, []);
  return <div id="shader" ref={$shader}></div>;
};

export { BubbleContent };
