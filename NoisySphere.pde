class NoisySphere {
   
   PVector position;
   PVector rotation;
   PShape sphere;
   PShader shader;
   float size;
   
   Line noiseAmntLine, noiseFreqLine;
   
   NoisySphere() { this(width/2.0, height/2.0, 0.0); }
  
   NoisySphere(float x, float y, float z) {
     position = new PVector(x, y, z);
     rotation = new PVector(0, 0, 0);
     size = width/4.0;
     init();
   }
   
 void init() {
   // Initialize Shader
   shader = loadShader("shaders/noisy-frag.glsl", "shaders/noisy-vert.glsl");
   shader.set("u_noise_amnt", 0.5);
   shader.set("u_noise_freq", 0.0);
   // Initialize Shape
   sphere = createShape(SPHERE, size);
   sphere.setTexture(loadImage("textures/marble.jpg"));
   sphere.setStroke(false);
   // GUI Bindings 
   noiseAmntLine = new Line();
   noiseFreqLine = new Line();
   setNoiseAmount(0.6);
 }
 
 void update() {
   shader.set("u_time", millis()*0.001);
   shader.set("u_noise_amnt", noiseAmntLine.value); 
   shader.set("u_noise_freq", noiseFreqLine.value); 
 }
 
 void display() {
      
   shader(shader);
   
   pushMatrix();
     
   translate(position.x, position.y, position.z);
   
   rotateX(rotation.x);
   rotateY(rotation.y);
   rotateZ(rotation.z);
   
   shape(sphere);
   
   popMatrix();
   
   resetShader();
 }
   
 void setNoiseAmount(float value)    { 
   noiseAmntLine.to(value, 10000);
 }
 
 void setNoiseFrequency(float value) {
   noiseFreqLine.to(value, 10000);
 }
}
