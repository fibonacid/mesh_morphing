/*
 *
 */
abstract class Orbiter {
  
   protected PVector origin;
   protected PVector polarPosition;
   protected PVector carthesianPosition;
   protected PVector polarSpeed;
  
   Orbiter() {
     polarSpeed = new PVector(0, PI/1024, 0.01);
     carthesianPosition = new PVector(width/2, height/2, 5000);
     origin = new PVector(width/2, height/2, 0);
     polarPosition = new PVector(5000, 0, PI/2);
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
     this(color(255));
   }  
  
   OrbitingLamp(color lightColor) {
     this.lightColor = lightColor;
   }
  
   void display() {
     move();    
     pushMatrix();
     translate(carthesianPosition.x, carthesianPosition.y, carthesianPosition.z * 0.25);
     fill(255, 0, 0);
     sphere(100);
     spotLight(red(lightColor), green(lightColor), blue(lightColor), 0, 0, 0, 0, 0, -1, PI/2, 1);
     popMatrix();
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
  
   void display() {
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
