/*
 * Base class to create elements that needs to orbit around a certain position
 */
abstract class Orbiter {
  
   PVector origin;                // Orbital center
   PVector polarPosition;         // Position in polar coordinates
   PVector carthesianPosition;    // Position in carthesian coordinates
   PVector polarSpeed;            // Speed of the object in polar coordinates
   
   /**
    * Class constructor with default origin at sketch center
    */
   Orbiter() {
      this(new PVector(width/2, height/2, 0));
   }
   
   /**
    * Class constructor with specific origin
    */
   Orbiter(PVector origin) {
     this.origin = origin;
     polarSpeed = new PVector(0, random(0.005), random(0.005));
     carthesianPosition = new PVector(width/2, height/2, 600);
     polarPosition = new PVector(500, 0, 0);
   }
   
   /**
    * Moves the object in the polar space according to the 
    * incremental value defined by polarSpeed
    */
   void move() {
     polarPosition.add(polarSpeed);
     sphericalToCartesian(polarPosition, carthesianPosition, origin);
   }
   
   /** Every Orbiter subclass must implements this method */
   abstract void apply();
}

/**
 * This class applies the Orbiter behaviour to
 * a colored spotlight
 */
class OrbitingLamp extends Orbiter {
  
   color lightColor;            // Color of the light
   color currentColor;          // Calculated color value of the light
   float stroboFreq = 0.1;     // Frequency of the strobo behaviour
   float angle = PI/4;          // Angle of the spotlights cone
   
   /**
    * @see Orbiter(Pvector origin)
    */
   OrbitingLamp(PVector origin) {
     this(origin, color(255,255,255));
   }  
  
   /**
    * Constructor with specific light color
    */
   OrbitingLamp(PVector origin, color lightColor) {
     super(origin);
     this.lightColor = lightColor;
     this.currentColor = lightColor;
   }
   
   /**
    * Updates the object attributes according to some logic
    */
   void update() {
     this.currentColor = lerpColor(color(0), this.lightColor, sharpLFO(stroboFreq));
   }
  
  /**
   * Places the spotlight into the scene
   */
   void apply() {
     spotLight(
        red(currentColor),       // Red component of the light
        green(currentColor),     // Green component of the light
        blue(currentColor),      // Blue component of the light
        carthesianPosition.x,    // x-coordinate of the light
        carthesianPosition.y,    // y-coordinate of the light
        carthesianPosition.z,    // z-coordinate of the light
        0,                       // direction along the x axis
        0,                       // direction along the y axis
        -1,                      // direction along the z axis
        angle,                   // angle of the spotlight cone
        1                        // exponent determining the center bias of the cone
     );
   }
}
