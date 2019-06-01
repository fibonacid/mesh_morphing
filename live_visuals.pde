/** ------------------------------------------------------
 *  author:        Lorenzo Rivosecchi
 *  title:         live_visuals
 *  description:   A sketch to make interactive visuals
 *  version:       0.0.0
 *  ------------------------------------------------------ */

PShader noiseShader;
PShape box;

void setup() {
  size(500,500, P3D);
  
  noiseShader = loadShader("shaders/noise_frag.glsl", "shaders/noise_vert.glsl");
  box = createShape(SPHERE,100);
  box.setTexture(loadImage("textures/marble.jpg"));
}

void draw() {
  background(0);
  
  shader(noiseShader);
   
  pushMatrix();
  translate(width/2.0, height/2.0);
  rotateY(radians(frameCount));
  fill(0,255,0);
  shape(box);
  popMatrix();
}
