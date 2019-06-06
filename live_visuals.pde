import peasy.PeasyCam;
import processing.sound.*;
import processing.video.*;
import themidibus.*;
import controlP5.*;

/** ------------------------------------------------------
 *  author:        Lorenzo Rivosecchi
 *  title:         live_visuals
 *  description:   A sketch to make interactive visuals
 *  version:       rebuild
 *  ------------------------------------------------------ */
 
 // Configuration file
JSONObject config;

// Session variables
boolean _fullscreen_ = false;
int _width_ = 500;
int _height_ = 500;

// 3D Scene
PeasyCam camera;
Mesh mesh;

// Runtime
float sceneClock = 0;
float sceneClockSpeed = 0.1;

void settings() {
  loadConfig();
  if (_fullscreen_) { fullScreen(P3D); }
  else { size(_width_, _height_, P3D); }
}

void setup() {
  mesh = new Mesh();
  camera = new PeasyCam(this, mesh.position.x, mesh.position.y, mesh.position.z, 1000);
  camera.setMinimumDistance(mesh.SIZE*0.5);
  camera.setMaximumDistance(mesh.SIZE*10.);
  
}

void draw() {
  
  background(0);
  directionalLight(255, 255, 255, 0, 0, -1);
  directionalLight(255, 255, 255, -1, 0, 1);
    
  sceneClock = millis() * sceneClockSpeed; // set global clock
  
  mesh.update();
  mesh.display();

  camera.beginHUD();
  showFramerate();
  camera.endHUD(); // always!
}

void keyPressed() {
   switch(key) {
     case '1':
       mesh.setMode(Mesh.WITH_TEXTURE);
       break;
     case '2':
       mesh.setMode(Mesh.NO_TEXTURE);
   }
}
