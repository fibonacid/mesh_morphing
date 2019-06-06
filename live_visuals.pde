import peasy.PeasyCam;
import processing.sound.*;
import processing.video.*;
import themidibus.*;
import controlP5.*;

/** ------------------------------------------------------
 *  author:        Lorenzo Rivosecchi
 *  title:         live_visuals
 *  description:   A sketch to make interactive visuals
 *  version:       0.1.0
 *  ------------------------------------------------------ */

/* Configuration file */
JSONObject config;

/* Session variables */
boolean _fullscreen_   = false;
int     _width_        = 500;
int     _height_       = 500;
boolean _eco_          = false;

/* State variables */
boolean showControls = true;

/* 3D Scene */
PeasyCam camera;
Mesh mesh;
OrbitingLamp[] lamps;
float sceneClock = 0;
float sceneClockSpeed = 0.1;

/* Audio */
AudioIn audioIn;
AudioIndicator audioIndicator;
EnvelopeFollower envf;

/* GUI */
ControlP5 gui;

void settings() {
  loadConfig();
  if (_fullscreen_) { 
    fullScreen(P3D);
  } else { 
    size(_width_, _height_, P3D);
  }
}

void setup() {
  
  // Initialize Scene
  mesh = new Mesh();
  createLamps();
  camera = new PeasyCam(this, mesh.position.x, mesh.position.y, mesh.position.z, 600);
  camera.setMinimumDistance(mesh.SIZE*0.5);
  camera.setMaximumDistance(mesh.SIZE*10.);
  
  // Initialize Audio
  audioIn = new AudioIn(this, 0);
  audioIn.start();
  audioIndicator = new AudioIndicator(this, audioIn);
  envf = new EnvelopeFollower(this, audioIn);
  
  createGUI(); // Initialize GUI

}

void draw() {

  background(0);

  sceneClock = millis() * sceneClockSpeed; // set global clock

  ambientLight(60, 60, 60);
  for (OrbitingLamp lamp : lamps) {
    lamp.move();
    lamp.update();
    lamp.apply();
  }

  mesh.update();
  mesh.scale(envf.getValue());
  mesh.rotate();
  mesh.display();
  
  if (showControls) {
    camera.beginHUD();
    // 2D Code here
    showFramerate();
    audioIndicator.display();
    gui.draw();
    camera.endHUD();
  }
}

void keyPressed() {  
  char k = Character.toUpperCase(key); 
  switch(k) {
  case '1':
    mesh.setMode(Mesh.WITH_TEXTURE);
    break;
  case '2':
    mesh.setMode(Mesh.NO_TEXTURE);
    break;
  case 'C':
    showControls = !showControls;
    break;
  }
}

/**
 *
 */
void createLamps() {
  if (_eco_) { 
    lamps = new OrbitingLamp[1];
  } else { 
    lamps = new OrbitingLamp[3];
  }
  for (int i = 0; i < lamps.length; i++) {
    lamps[i] = new OrbitingLamp(mesh.position, color(255, 0, 0));
  }
}
