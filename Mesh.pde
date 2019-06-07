class Mesh {
    
   private PVector position;
   private PVector rotation;
   private PVector rotationSpeed;
   private PShape shape;
   private final float SIZE = width/4;
   
   private PImage DEFAULT_TEXTURE = loadImage("data/textures/marble.jpg");
   private final PShader TEXLIGHT_SHADER  = loadShader("shaders/TexLightFrag.glsl", "shaders/TexLightVert.glsl");
   private final PShader LIGHT_SHADER = loadShader("shaders/LightFrag.glsl", "shaders/LightVert.glsl");
   private PShader currentShader;
   
   final static int WITH_TEXTURE = 1;
   final static int NO_TEXTURE = 2;
   
   private final Line vertNoiseAmount = new Line(1.0);
   private final Line vertNoiseSpeed  = new Line(0.5);
   private final Line fragNoiseAmount = new Line(1.0);
   private final Line fragNoiseSpeed  = new Line(0.5);
  
   Mesh() {
     if (_eco_) { sphereDetail(30); }
     else       { sphereDetail(150);  }   
     shape = createShape(SPHERE, SIZE);
     
     position = new PVector(width/2, height/2, 0);
     rotation = new PVector(0, 0, 0);
     rotationSpeed = new PVector(random(0, PI/1024), random(0, PI/1024), random(0, PI/1024));
     
     shape.setTexture(DEFAULT_TEXTURE);
     shape.setStroke(false);

     currentShader = LIGHT_SHADER;
   }
   
   void update() {
     currentShader.set("u_time", sceneClock);
     currentShader.set("u_vert_noise_amount", vertNoiseAmount.value);
     currentShader.set("u_vert_noise_speed", vertNoiseSpeed.value);
     currentShader.set("u_frag_noise_amount", fragNoiseAmount.value);
     currentShader.set("u_frag_noise_speed", fragNoiseSpeed.value);
   }
   
   void rotate() {
     rotation.add(rotationSpeed);
   }
   
   void display() {     
     shader(currentShader);
          
     pushMatrix();
     
     translate(position.x, position.y, position.z);
     rotateX(rotation.x);
     rotateY(rotation.y);
     rotateZ(rotation.z);
     
     shape(shape);
     popMatrix();
  
     resetShader();
   }
   
   /**
    *
    */
   void setMode(int mode) {
      switch(mode) {
         case WITH_TEXTURE:
           currentShader = TEXLIGHT_SHADER;
           break;
         case NO_TEXTURE:
           currentShader = LIGHT_SHADER;
           break;
      }
   }
   
   void setVertNoiseAmount(float value, float time) {
      vertNoiseAmount.to(value, time);
   }
   
   void setVertNoiseSpeed(float value, float time) {
      vertNoiseSpeed.to(value, time);
   }
   
   void setFragNoiseAmount(float value, float time) {
      fragNoiseAmount.to(value, time); 
   }
   
   void setFragNoiseSpeed(float value, float time) {
      fragNoiseSpeed.to(value, time); 
   }
   
   void scale(float value) {
      currentShader.set("u_scale", value);
   }
}
