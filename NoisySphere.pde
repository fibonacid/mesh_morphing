class NoisySphere {
   
   PVector position;
   PVector rotation;
   PShape sphere;
   PShader shader;
   float size;
   
   NoisySphere() { this(width/2.0, height/2.0, 0.0); }
  
   NoisySphere(float x, float y, float z) {
     position = new PVector(x, y, z);
     rotation = new PVector(0, 0, 0);
     size = width/4.0;
     init();
   }
   
   void init() {
     shader = loadShader("shaders/noisy-frag.glsl", "shaders/noisy-vert.glsl");
     sphere = createShape(SPHERE, size);
     sphere.setTexture(loadImage("textures/marble.jpg"));
     sphere.setStroke(false);
   }
   
   void update() {
     shader.set("u_time", millis()*0.0001);
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
   }
}
