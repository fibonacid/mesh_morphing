class Mesh {
    
   private PVector position;
   private PShape shape;
   private final float SIZE = width/4;
   
   private PImage DEFAULT_TEXTURE = loadImage("data/textures/marble.jpg");
   private final PShader TEXLIGHT_SHADER  = loadShader("shaders/TexLightFrag.glsl", "shaders/TexLightVert.glsl");
   private final PShader LIGHT_SHADER = loadShader("shaders/LightFrag.glsl", "shaders/LightVert.glsl");
   private PShader currentShader;
  
   Mesh() {
     sphereDetail(200);
     shape = createShape(SPHERE, SIZE);
     position = new PVector(width/2, height/2, 0);
     shape.setTexture(DEFAULT_TEXTURE);
     shape.setStroke(false);
     
     String[] noise = loadStrings("shaders/cnoise3.glsl");
     currentShader = TEXLIGHT_SHADER;
   }
   
   void update() {
     currentShader.set("u_time", sceneClock);
   }
   
   void display() {
     
     shader(currentShader);
          
     pushMatrix();
     translate(position.x, position.y, position.z);
     
     shape(shape);
     
     popMatrix();
   
     resetShader();
   }
}
