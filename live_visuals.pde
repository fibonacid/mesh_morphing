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

 // Configuration file
JSONObject config;

// Session variables
boolean _fullscreen_ = false;
int _width_ = 500;
int _height_ = 500;
boolean _eco_ = false;

// 3D Scene
PeasyCam camera;
Mesh mesh;
OrbitingLamp[] lamps;

// Runtime
float sceneClock = 0;
float sceneClockSpeed = 0.1;

// Audio
AudioIn audioIn;
AudioIndicator audioIndicator;
EnvelopeFollower envf;

void settings() {
  loadConfig();
  if (_fullscreen_) { fullScreen(P3D); }
  else { size(_width_, _height_, P3D); }
}

void setup() {
  mesh = new Mesh();
  createLamps();
  camera = new PeasyCam(this, mesh.position.x, mesh.position.y, mesh.position.z, 600);
  camera.setMinimumDistance(mesh.SIZE*0.5);
  camera.setMaximumDistance(mesh.SIZE*10.);
  
  audioIn = new AudioIn(this, 0);
  audioIn.start();
  audioIndicator = new AudioIndicator(this, audioIn);
  envf = this.Utils.new EnvelopeFollower(this, audioIn);
  
}

void draw() {

  background(0);
  //directionalLight(255, 255, 255, 0, 0, -1);
  //directionalLight(255, 255, 255, -1, 0, 1);

  sceneClock = millis() * sceneClockSpeed; // set global clock
  
  ambientLight(60,60,60);
  for (OrbitingLamp lamp: lamps) {
    lamp.move();
    lamp.update();
    lamp.apply(); 
  }

  mesh.update();
  mesh.scale(envf.getValue());
  mesh.rotate();
  mesh.display();

  camera.beginHUD();
  showFramerate();
  audioIndicator.display();
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

void createLamps() {
    if (_eco_) { lamps = new OrbitingLamp[1]; }
    else       { lamps = new OrbitingLamp[3]; }
     for(int i = 0; i < lamps.length; i++) {
      lamps[i] = new OrbitingLamp(mesh.position, color(255,0,0));
    }
}

/**
 *
 */
void showFramerate() {
  pushStyle();
  fill(255);
  textSize(15);
  text(int(frameRate)+" FPS", 15, height - 30, width -15, height - 30);
  popStyle();
}
