/*
 *
 */
abstract class Orbiter {
  
   protected PVector origin;
   protected PVector polarPosition;
   protected PVector carthesianPosition;
   protected PVector polarSpeed;
  
   Orbiter() {
     polarSpeed = new PVector(0, 0.02, 0.01);
     carthesianPosition = new PVector(width/2, height/2, 5000);
     origin = new PVector(width/2, height/2, 0);
     polarPosition = new PVector(5000, 0, random(0,PI));
   }
   
   void move() {
     polarPosition.add(polarSpeed);
     sphericalToCartesian(polarPosition, carthesianPosition, origin);
   }
   
   abstract void apply();
}

/**
 *
 */
class OrbitingLamp extends Orbiter {
  
  color lightColor;
  
   OrbitingLamp() {
     this(color(255));
   }  
  
   OrbitingLamp(color lightColor) {
     this.lightColor = lightColor;
   }
  
   void apply() {
      spotLight (
        red(lightColor),       // red
        green(lightColor),     // green
        blue(lightColor),      // blue
        carthesianPosition.x,  // x position
        carthesianPosition.y,  // y position
        carthesianPosition.z,  // z position
        0, -1, -1,             // directions
        PI/8,                  // cone angle
        1                      // density
      );
   }
}

/**
 *
 */
class OrbitingCamera extends Orbiter {
   
   OrbitingCamera() {
      //polarSpeed.y = 0.001;
      //polarSpeed.z = 0.02;
   }
  
   void apply() {
     //move();
     //polarPosition.x = 0.5 + 0.5 * sin(millis()*0.0001) * 1000 + 500;
     camera(
        carthesianPosition.x, 
        carthesianPosition.y,
        (height/2) / tan(PI/6), //carthesianPosition.z,
        origin.x,
        origin.y,
        origin.z,
        0.0,
        1.0,
        0.0
     );
     //perspective();
   }
}
