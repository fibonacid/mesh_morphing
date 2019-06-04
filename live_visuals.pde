import processing.sound.*;
import processing.video.*;
import themidibus.*;
import controlP5.*;

/** ------------------------------------------------------
 *  author:        Lorenzo Rivosecchi
 *  title:         live_visuals
 *  description:   A sketch to make interactive visuals
 *  version:       0.0.8
 *  ------------------------------------------------------ */

MidiBus midibus;
Capture webcam;
AudioIn input;
Amplitude loudness;
AudioIndicator audioIndicator;

NoisySphere noisySphere;
ControlP5 cp5;
OrbitingLamp[] lights;

void setup() {
  size(960,720, P3D);
  
  midibus = new MidiBus(this, 0, 0);
  MidiBus.list();

  // Initialize Webcam
  String[] cameras = Capture.list();
  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    webcam = new Capture(this, 640, 480);
  } if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    printArray(cameras);

    // The camera can be initialized directly using an element
    // from the array returned by list():
    webcam = new Capture(this, cameras[0]);
    // Or, the settings can be defined based on the text in the list
    //cam = new Capture(this, 640, 480, "Built-in iSight", 30);
    
    // Start capturing the images from the camera
    webcam.start();
  }
  
  // Initialize Audio Input
  input = new AudioIn(this, 0);
  input.start();
  // Create a new Amplitude analyzer
  loudness = new Amplitude(this);
  // Patch the input to the volume analyzer
  loudness.input(input);
  audioIndicator = new AudioIndicator(loudness);
  
  // Create scene elements
  noisySphere = new NoisySphere(width/2.0, height/2.0, 0);
  lights = new OrbitingLamp[4];
  for(int i=0; i < lights.length; i++) {
     lights[i] = new OrbitingLamp(color(255,0,0)); 
  }
  
}

void draw() {

  background(0); 
  
  camera();
  spotLight(160,160,160, width/2, height/2, 1000, 0, 0, -1, PI/8, 1);
  
  if (webcam.available() == true) {
    webcam.read();
  }
  
  for (OrbitingLamp light: lights) {
    light.move();
    light.apply(); 
  }
  
  noisySphere.rotation.y += 0.005;
  noisySphere.setTexture(webcam);
  noisySphere.update();
  noisySphere.display();
  
  hint(DISABLE_DEPTH_TEST);
  camera();
  noLights();
  // 2D code
  showFramerate();
  audioIndicator.display();
  hint(ENABLE_DEPTH_TEST);
  
}

void showFramerate() {
  pushStyle();
  fill(255);
  textSize(15);
  text(int(frameRate)+" FPS", 15, height - 30, width -15, height - 30);
  popStyle();
}
