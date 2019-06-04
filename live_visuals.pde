import themidibus.*;
import controlP5.*;

/** ------------------------------------------------------
 *  author:        Lorenzo Rivosecchi
 *  title:         live_visuals
 *  description:   A sketch to make interactive visuals
 *  version:       0.0.7
 *  ------------------------------------------------------ */

MidiBus midibus;

NoisySphere noisySphere;
ControlP5 cp5;
OrbitingLamp orbitingLight;

void setup() {
  size(960,720, P3D);
  
  midibus = new MidiBus(this, 0, 0);
  MidiBus.list();

  noisySphere = new NoisySphere(width/2.0, height/2.0, 0);
  orbitingLight = new OrbitingLamp(#ff0000); // red
}

void draw() {

  background(0); 
  
  ambientLight(150,150,150);
  camera();
  
  orbitingLight.move();
  orbitingLight.apply();
  
  //noisySphere.rotation.x += 0.005;

  noisySphere.update();
  noisySphere.display();
}
