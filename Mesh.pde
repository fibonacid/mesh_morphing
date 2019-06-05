class Mesh {
    
   private PVector position;
   private PShape shape;
   private final float SIZE = width/4;
   
   private PImage DEFAULT_TEXTURE = loadImage("data/textures/marble.jpg");
   private final PShader TEXTURED_SHADER  = loadShader("shaders/texturedFrag.glsl", "shaders/texturedVert.glsl");
   private final PShader UNTEXTURED_SHADER = loadShader("shaders/untexturedFrag.glsl", "shaders/untexturedVert.glsl");
  
   Mesh() {
     shape = createShape(SPHERE, SIZE);
     position = new PVector(width/2, height/2, 0);
     shape.setTexture(DEFAULT_TEXTURE);
   }
   
   void update() {
     
   }
   
   void display() {
     
     shader(TEXTURED_SHADER);
     
     pushMatrix();
     translate(position.x, position.y, position.z);
     
     shape(shape);
     
     popMatrix();
   
     resetShader();
   }
}
