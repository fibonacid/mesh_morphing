class Mesh {
    
   private PVector position;
   private PShape shape;
   private final float SIZE = width/4;
   
   private PImage DEFAULT_TEXTURE = loadImage("data/textures/marble.jpg");
   private final PShader TEXLIGHT_SHADER  = loadShader("shaders/TexLightFrag.glsl", "shaders/TexLightVert.glsl");
   private final PShader LIGHT_SHADER = loadShader("shaders/LightFrag.glsl", "shaders/LightVert.glsl");
   private PShader currentShader;
   
   final static int WITH_TEXTURE = 1;
   final static int NO_TEXTURE = 2;
  
   Mesh() {
     if (_eco_) { sphereDetail(30); }
     else       { sphereDetail(100);  }   
     shape = createShape(SPHERE, SIZE);
     position = new PVector(width/2, height/2, 0);
     shape.setTexture(DEFAULT_TEXTURE);
     shape.setStroke(false);
     
     String[] noise = loadStrings("shaders/cnoise3.glsl");
     currentShader = TEXLIGHT_SHADER;
   }
   
   void update() {
     currentShader.set("u_time", sceneClock);
     currentShader.set("u_noise_amount", 1.0);
   }
   
   void display() {
     
     shader(currentShader);
          
     pushMatrix();
     translate(position.x, position.y, position.z);
     
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
   
   void setNoiseAmount(float value) {
      currentShader.set("u_noise_amount", value);
   }
   
   void scale(float value) {
      currentShader.set("u_scale", value);
   }
}
