class Mesh {
    
   private PVector position;
   private PShape shape;
   private final float SIZE = width/4;
  
   Mesh() {
     shape = createShape(SPHERE, SIZE);
     position = new PVector(width/2, height/2, 0);
   }
   
   void update() {
     
   }
   
   void display() {
     pushMatrix();
     translate(position.x, position.y, position.z);
     shape(shape);
     popMatrix();
   }
}
