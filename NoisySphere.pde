class NoisySphere {
   
   private PVector position;
   private PVector rotation;
   private PShape sphere;
   private PShader shader;
   float size;
   
   NoisySphere() { this(width/2.0, height/2.0, 0.0); }
  
   NoisySphere(float x, float y, float z) {
     position = new PVector(x, y, z);
     rotation = new PVector(0, 0, 0);
     size = width/4.0;
     init();
   }
   
   void init() {
     shader = loadShader("shaders/noise_frag.glsl", "shaders/noise_vert.glsl");
     sphere = createShape(SPHERE, size);
     sphere.setTexture(loadImage("textures/marble.jpg"));
     sphere.setStroke(false);
   }
   
   void update() {
     
   }
   
   void display() {
     shader(shader);
     pushMatrix();
     translate(position.x, position.y, position.z);
     shape(sphere);
     popMatrix();
   }
      
   /** GETTERS AND SETTERS */
   
   void setPosition(PVector position) { this.position = position; }
   void setRotation(PVector rotation) { this.rotation = rotation; }
   void setSize(float size)           { this.size     = size;     }

   PVector getPosition() { return this.position; }
   PVector getRotation() { return this.rotation; }
   float   getSize()     { return this.size;   }
}
