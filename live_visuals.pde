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
}

void draw() {
  
  background(0);
  
  sceneClock = millis() * sceneClockSpeed; // set global clock
  
  mesh.update();
  mesh.display();
 
}
