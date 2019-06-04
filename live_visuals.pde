import controlP5.*;

/** ------------------------------------------------------
 *  author:        Lorenzo Rivosecchi
 *  title:         live_visuals
 *  description:   A sketch to make interactive visuals
 *  version:       0.0.7
 *  ------------------------------------------------------ */

NoisySphere noisySphere;
ControlP5 cp5;
OrbitingLamp spotlight;
OrbitingCamera camera;

void setup() {
  size(960,720, P3D);
  
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  cp5.addSlider("noise_amount").setRange(0.0, 1.0).linebreak();
  cp5.addSlider("noise_frequency").setRange(0.0, 1.0);
  
  noisySphere = new NoisySphere(width/2.0, height/2.0, 0);
  spotlight = new OrbitingLamp();
  camera = new OrbitingCamera();
}

void draw() {

  background(0); 
  
  ortho();
  
  camera.display();
  
  lights();
  //camera(width/2, height/2, 1000, width/2, height/2, 0, -1, 0, 0);
  
  //ambientLight(200, 200, 200);

  //spotLight(255, 255, 255, width/2, height/2, 500, 0, 0, -1, PI/4, 1);
 
  
  spotlight.display();
  
  //noisySphere.rotation.x += 0.005;
  
  fill(0,255, 0);
  //rect(40, 40, width-40, height-40);
  
  noisySphere.update();
  noisySphere.display();

  //cp5.draw();
}
