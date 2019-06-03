import controlP5.*;

/** ------------------------------------------------------
 *  author:        Lorenzo Rivosecchi
 *  title:         live_visuals
 *  description:   A sketch to make interactive visuals
 *  version:       0.0.4
 *  ------------------------------------------------------ */

NoisySphere noisySphere;
ControlP5 cp5;

void setup() {
  size(960,720, P3D);
  
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  cp5.addSlider("noise_amount").setRange(0.0, 1.0).linebreak();
  cp5.addSlider("noise_frequency").setRange(0.0, 1.0);
  
  noisySphere = new NoisySphere(width/2.0, height/2.0, 0);
}

void draw() {

  background(0); 
  
  camera(width/2, width/2, 1000, width/2, height/2, 1, 0, 1, 0);
  
  ambientLight(0, 20, 10);
  spotLight(255, 50, 50, mouseX, mouseY, 1000, 0, 0, -1, PI/16, 1);
  
  noisySphere.rotation.x += 0.005;
  
  noisySphere.update();
  noisySphere.display();

  cp5.draw();
}
