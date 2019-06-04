/*
 *
 */
abstract class Orbiter {
  
   PVector origin;
   PVector polarPosition;
   PVector carthesianPosition;
   PVector polarSpeed;
  
   Orbiter() {
     polarSpeed = new PVector(0, 0.01, 0.01);
     carthesianPosition = new PVector(width/2, height/2, 1000);
     polarPosition = new PVector(1000, 0, 0);
   }
   
   void move() {
     polarPosition.add(polarSpeed);
     sphericalToCartesian(polarPosition, carthesianPosition, origin);
   }
   
   abstract void display();
}

/**
 *
 */
class OrbitingLamp extends Orbiter {
  
  color lightColor;
  
   OrbitingLamp() {
     this(color(255,0,0));
   }  
  
   OrbitingLamp(color lightColor) {
     this.lightColor = lightColor;
   }
  
   void display() {
     spotLight(
        red(lightColor), 
        green(lightColor), 
        blue(lightColor),
        carthesianPosition.x, 
        carthesianPosition.y,
        carthesianPosition.z, 
        0, 
        -1, 
        -1, 
        PI/8, 
        1
     );
   }
}
