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
  
  noisySphere.rotation.x += 0.01;
  
  noisySphere.update();
  noisySphere.display();
}
