/** ------------------------------------------------------
 *  author:        Lorenzo Rivosecchi
 *  title:         live_visuals
 *  description:   A sketch to make interactive visuals
 *  version:       0.0.1
 *  ------------------------------------------------------ */

PShader noiseShader;
PShape box;

void setup() {
  size(500,500, P3D);
  
  noiseShader = loadShader("shaders/noise_frag.glsl", "shaders/noise_vert.glsl");
  box = createShape(SPHERE,100);
  box.setTexture(loadImage("textures/marble.jpg"));
  box.setStroke(false);
}

void draw() {
  
  background(0);
  
  shader(noiseShader);
  
  pointLight(255, 255, 255, width/2, height/2, 500);  
    
  pushMatrix();
  translate(width/2.0, height/2.0);
  rotateY(radians(frameCount));
  shape(box);
  
  popMatrix();
}
