/*
 *
 */
abstract class Orbiter {
  
   PVector origin;
   PVector polarPosition;
   PVector carthesianPosition;
   PVector polarSpeed;
     
   Orbiter() {
      this(new PVector(width/2, height/2, 0));
   }
   
   Orbiter(PVector origin) {
     this.origin = origin;
     polarSpeed = new PVector(0, random(0.005), random(0.005));
     carthesianPosition = new PVector(width/2, height/2, 600);
     polarPosition = new PVector(1000, 0, 0);
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
  
   color lightColor, currentColor;
   float stroboFreq = 0.25;
   float angle = PI/4; 
    
   OrbitingLamp(PVector origin) {
     this(origin, color(255,255,255));
   }  
  
   OrbitingLamp(PVector origin, color lightColor) {
     super(origin);
     this.lightColor = lightColor;
     this.currentColor = lightColor;
   }
      
   void update() {
     this.currentColor = lerpColor(color(0), this.lightColor, sharpLFO(stroboFreq));
   }
  
   void apply() {
     spotLight(
        red(currentColor), 
        green(currentColor), 
        blue(currentColor),
        carthesianPosition.x, 
        carthesianPosition.y,
        carthesianPosition.z, 
        0, 
        -1, 
        -1, 
        angle, 
        1
     );
   }
}
