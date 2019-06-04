/*
 *
 */
abstract class Orbiter {
  
   PVector origin;
   PVector polarPosition;
   PVector carthesianPosition;
   PVector polarSpeed;
  
   Orbiter() {
     polarSpeed = new PVector(0, random(0.05), random(0.05));
     carthesianPosition = new PVector(width/2, height/2, 1000);
     origin = new PVector(width/2, height/2, 0);
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
     move();
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

/**
 *
 */
class OrbitingCamera extends Orbiter {
   
   OrbitingCamera() {
      polarSpeed.y = 0.001;
      polarSpeed.z = 0.02;
   }
  
   void display() {
     move();
     polarPosition.x = 0.5 + 0.5 * sin(millis()*0.0001) * 1000 + 500;
     camera(
        carthesianPosition.x, 
        carthesianPosition.y,
        carthesianPosition.z,
        origin.x,
        origin.y,
        origin.z,
        0.0,
        -1.0,
        0.0
     );
     perspective();
   }
}
