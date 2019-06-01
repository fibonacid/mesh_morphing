/** ------------------------------------------------------
 *  author:        Lorenzo Rivosecchi
 *  title:         live_visuals
 *  description:   A sketch to make interactive visuals
 *  version:       0.0.0
 *  ------------------------------------------------------ */

PShader noiseShader;

void setup() {
  size(500,500, P3D);
  
  noiseShader = loadShader("shaders/noise_frag.glsl", "shaders/noise_vert.glsl");
}

void draw() {
  background(0);
  
  shader(noiseShader);
}
