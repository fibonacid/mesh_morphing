import processing.sound.*;
import processing.video.*;
import com.hamoid.*;
import peasy.PeasyCam;
import controlP5.*;
import java.time.LocalDateTime;
import java.time.Instant;
import java.time.format.DateTimeFormatter;

/** ----------------------------------------------------------------------------------------- *
 *  author:        Lorenzo Rivosecchi                                                         *
 *  title:         mesh_morphing                                                              *
 *  description:   An interactive 3D scene with a morphing sphere.                            *
 *  version:       0.2.1                                                                      *
 *  ----------------------------------------------------------------------------------------- */

/* Configuration file */
JSONObject config;

/* Environment */
JSONObject ENV;
boolean ENV_FORGET_FFMPEG;
String ENV_FFMPEG_PATH;

/* Session variables:
 * This variables can be overwritten through the file config/settings.json. */
boolean _fullscreen_ = false;
int     _width_ = 960;             // Window width in pixels
int     _height_ = 720;             // Window height in pixels
boolean _eco_ = false;           // Low resolution mode
String _export_filename_ = "mesh_morphing";
String _export_quality_ = "standard";

final String DEFAULT_TEXTURE = "marble.jpg";
String  _texture_            = DEFAULT_TEXTURE;

/* State variables */
boolean showControls = true;       // GUI visibility 
Line lightIntensity;               // Brightness of the 3D scene
float sceneClock = 0;              // Master clock of the scene
float sceneClockSpeed = 0.25;       // Time scaling factor of the master clock

/* 3D Scene */
PeasyCam camera;                   // Camera controllable through the mouse
Mesh mesh;                         // Main element of the scene
OrbitingLamp[] lamps;              // Array of spotlights to light the scene

/* Audio */
AudioIn audioIn;                   // Audio Input
Amplitude rms;                     // RMS Analyzer
EnvelopeFollower envf;             // 

// Video Export
VideoExport videoExport;
boolean isRecording = false;
String exportDir = "export/";
float recorderSampleTime = 0;
float recorderNextSampleTime = 0;

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
Toggle recordToggle;               //
Textarea myTextarea;               //
ColorWheel colorWheel;
Println console;                   //
StringList consoleQueue;           //
String[] tips;
String lastTip;

// Utils
DateTimeFormatter fileDTF = DateTimeFormatter.ofPattern("yyyy-MM-dd-HH-mm");

/**
 * This function gets called right before setup.
 * Here is possible to set window size using variables
 */
void settings() {
  consoleQueue = new StringList();
  
  // Load sketch configuration
  loadConfig();
  loadEnvironment();
  
  if (_fullscreen_) { 
    fullScreen(P3D);
  } else { 
    size(_width_, _height_, P3D);
  }
}

/** */
void setup() {
  
  // Set framerate
  frameRate(60);
  
  // Initialize Scene
  mesh = new Mesh();
  createLamps(); // find me below
  lightIntensity = new Line(0.5);
  
  // Create Camera
  camera = new PeasyCam(this, mesh.position.x, mesh.position.y, mesh.position.z, 600);
  camera.setMinimumDistance(mesh.SIZE*0.5);
  camera.setMaximumDistance(mesh.SIZE*10.);
  camera.setActive(false);
   
  // Initialize Audio
  audioIn = new AudioIn(this, 0);
  audioIn.start();
  
  envf = new EnvelopeFollower(this, audioIn);
  rms = new Amplitude(this);
  rms.input(audioIn);
  
  // Initialize GUI
  createGUI();
      
  /* From this line on println will appear on 
   * the gui console of the sketch */
  console.play();
  
   
  // Print some tips
  tips = loadStrings("tips.txt");
  if (tips.length > 0) println("Hello, here are some tips\n");
  for(String tip: tips) {
    printTip(tip); // find me in utils tab
  }
  println("\nHave fun ! :)\n");
  for (String line: consoleQueue) { println(line); }
  
  // Initialize VideoExport
  videoExport = new VideoExport(this);
  setupVideoExport();
}

void draw() {

  background(0);

  sceneClock = frameCount * sceneClockSpeed; // set global clock
  
  float b = 255*lightIntensity.value;
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
  
  // If recording has been activated
  if (isRecording) {
     try {
       // Save current frame
       videoExport.saveFrame();
       // Show duration of movie
       recorderSampleTime = millis();
       if (recorderSampleTime > recorderNextSampleTime) {
         recordingProgress();
         recorderNextSampleTime = recorderSampleTime + 1000;
       }
     } // If an error is raised:
     catch (Error error) {
       // Print it but keep sketch running
       error.printStackTrace();
     }
  }
  
  // If user has choose to see the controls
  if (showControls) {
    // Call this method to keep the 3D camera from
    // affecting the 2D display of the GUI.
    camera.beginHUD();
    // ----------------
    //  2D FIX ENABLED
    // ----------------
    // visualize audio level
    audioIndicator.setValue(rms.analyze());
    try {
      // Draw GUI
      gui.draw(); 
    }
    catch (Exception e) {
      e.printStackTrace(); 
    }
    // -----------------
    //  2D FIX DISABLED
    // -----------------
    camera.endHUD();
  }
}

/**
 *
 */
void keyPressed() {  
  char k = Character.toUpperCase(key);
  if (key == CODED) {
    if (keyCode == ALT) {
       camera.setActive(true);
       println("[KEY]\tAlt Pressed: use your mouse to move around");
    } 
  } else {
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
}

/**
 *
 */
void keyReleased() {
  if (key == CODED) {
    if (keyCode == ALT) {
       println("[KEY]\tAlt Released: camera is locked. Press again to move around");
       camera.setActive(false); 
    }
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
    lamps[i] = new OrbitingLamp(mesh.position, color(255, 255, 255));
  }
}
