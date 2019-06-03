/** ------------------------------------------------------
 *  author:        Lorenzo Rivosecchi
 *  title:         live_visuals
 *  description:   A sketch to make interactive visuals
 *  version:       0.0.1
 *  ------------------------------------------------------ */

NoisySphere noisySphere;

void setup() {
  size(500,500, P3D);
  
  noisySphere = new NoisySphere();
}

void draw() {
  
  background(0);
  
  pointLight(255, 255, 255, width/2, height/2, 500);
  
  noisySphere.rotation.x += 0.001;
  
  noisySphere.update();
  noisySphere.display();
}
