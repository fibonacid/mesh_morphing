import peasy.PeasyCam;
import processing.sound.*;
import processing.video.*;
import controlP5.*;

/** ----------------------------------------------------------------------------------------- *
 *  author:        Lorenzo Rivosecchi                                                         *
 *  title:         mesh_morphing                                                              *
 *  description:   A sketch to dive deep into the inner workings of a processing 3D scene.    *
 *  version:       0.1.5                                                                      *
 *  ----------------------------------------------------------------------------------------- */

/* Configuration file */
JSONObject config;

/* Session variables:
 * This variables can be overwritten through the file config/settings.json. */
boolean _fullscreen_   = false;
int     _width_        = 960;      // Window width in pixels
int     _height_       = 720;      // Window height in pixels
boolean _eco_          = false;    // Low resolution mode

/* State variables */
boolean showControls = true;       // GUI visibility 
float lightIntensity = 0.2;        // Brightness of the 3D scene
float sceneClock = 0;              // Master clock of the scene
float sceneClockSpeed = 0.1;       // Time scaling factor of the master clock

/* 3D Scene */
PeasyCam camera;                   // Camera controllable through the mouse
Mesh mesh;                         // Main element of the scene
OrbitingLamp[] lamps;              // Array of spotlights to light the scene

/* Audio */
AudioIn audioIn;                   // Audio Input
Amplitude rms;                     // RMS Analyzer
EnvelopeFollower envf;             // 

/* GUI */
ControlP5 gui;                     // Graphic User Interface
Slider vertNoiseAmountSlider;      //
Slider vertNoiseSpeedSlider;       //
Slider fragNoiseAmountSlider;      //
Slider fragNoiseSpeedSlider;       //
Slider audioSensitivitySlider;     //
Slider ambientLightSlider;         //
Slider audioIndicator;             //
RadioButton meshModeRadio;         //
Textarea myTextarea;               //
Println console;                   //

/**
 * This function gets called right before setup.
 * Here is possible to set window size using variables
 */
void settings() {
  // Load sketch configuration
  loadConfig();
  if (_fullscreen_) { 
    fullScreen(P3D);
  } else { 
    size(_width_, _height_, P3D);
  }
}

/** */
void setup() {
  
  // Initialize Scene
  mesh = new Mesh();
  createLamps(); // find me below
  
  // Create Camera
  camera = new PeasyCam(this, mesh.position.x, mesh.position.y, mesh.position.z, 600);
  camera.setMinimumDistance(mesh.SIZE*0.5);
  camera.setMaximumDistance(mesh.SIZE*10.);
   
  // Initialize Audio
  audioIn = new AudioIn(this, 0);
  audioIn.start();
  
  envf = new EnvelopeFollower(this, audioIn);
  rms = new Amplitude(this);
  rms.input(audioIn);
  
  // Initialize GUI
  createGUI(); // find me in gui tab
  
  console.play(); // enable on screen messages
  println("Hello ! Here are some instructions\n");
  println("\t- Press C to hide controls");
  println("\t- Press Shift to move camera around with your mouse");
  println("\nHave fun ! :)");
}

void draw() {

  background(0);

  sceneClock = millis() * sceneClockSpeed; // set global clock
  
  float b = 255*lightIntensity;
  ambientLight(b,b,b);
  
  // Update and apply lights
  for (OrbitingLamp lamp : lamps) {
    lamp.move();
    lamp.update();
    lamp.apply();
  }
  
  // Update and display mesh
  mesh.update();
  mesh.scale(envf.getValue());
  mesh.rotate();
  mesh.display();
  
  if (showControls) {
    camera.beginHUD();
    // 2D Code here
    audioIndicator.setValue(rms.analyze()); // visualize audio level
    gui.draw();
    camera.endHUD();
  }
}

/**
 *
 */
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
 * Creates instances of class OrbitingLamp (found in Orbiter tab)
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
