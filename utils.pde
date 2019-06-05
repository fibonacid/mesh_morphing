/**
 *
 */
class Line implements Runnable {
  
  final int SLEEP_TIME = 2;
  float timestamp;
  float destination;
  float value = 0;
  float duration = 500;
  Thread ease = new Thread(this);
  
  Line() {
    this.value = 0;
    ease.start();
  }
  
  void to(float destination) {
    timestamp = millis();
    this.destination = destination;
  }

  void to(float destination, float duration) {
    timestamp = millis();
    this.destination = destination;
    this.duration = duration;
  }
  
  float delta() {
    return millis() - timestamp;
  }
  
  // line.to(1, 10, 1000);
  
  public void run() {
     while(true) {
        try {
          float time = delta();
          if (time <= duration) {
            float angle = (destination - value) / duration;
            value = value + angle * time; //<>// //<>//
          } else {
            
          }
          ease.sleep(SLEEP_TIME);
        } catch (Exception e) {
          
        }
     } 
  }
}

/**
 Convert a set of cartesian coordinates to spherical coordinates.
 The cartesian coordinates are about the origin [0,0,0] unless 
 another origin is specified.
 
 @ param xyz cartesian coordinates to convert
 @ param rtp PVector to hold caculated spherical coordinates (optional)
 @ param origin the xyz coordinates origin in 3D space (optional)
 @ return a PVector holding the spherical coordinates
 */
PVector cartesianToSpherical(PVector xyz, PVector rtp, PVector origin) {
  // Create a new PVector only if the user has not provided one
  if (rtp == null) {
    rtp = new PVector();
  }
  // In most cases the origin will be [0,0,0] this avoids the need to create a
  // PVector when an origin is not provided
  float ox = xyz.x, oy = xyz.y, oz = xyz.z;
  if (origin != null) {
    ox -= origin.x;
    oy -= origin.y;
    oz -= origin.z;
  }
  float rad = sqrt(ox*ox + oy*oy + oz*oz);
  if (rad != 0) {
    rtp.x = rad;
    rtp.y = atan2(oy, ox);
    rtp.z = acos(oz / rad);
  }
  return rtp;
}
 
/**
 Convert a set of spherical coordinates to cartesian coordinates.
 The spherical coordinates are about the origin [0,0,0] unless 
 another origin is specified.
 
 @ param rtp spherical coordinates to convert
 @ param xyz PVector to hold caculated cartesian coordinates (optional)
 @ param origin the xyz coordinates origin in 3D space (optional)
 @ return a PVector holding the cartesian coordinates
 */
PVector sphericalToCartesian(PVector rtp, PVector xyz, PVector origin) {
  // Create a new PVector only if the user has not provided one
  if (xyz == null) {
    xyz = new PVector();
  }
  // In most cases the origin will be [0,0,0] this avoids the need to create a
  // PVector when an origin is not provided
  float ox=0, oy=0, oz=0;
  if (origin != null) {
    ox = origin.x;
    oy = origin.y;
    oz = origin.z;
  }
  float sin_p = sin(rtp.z);
  xyz.x = rtp.x * cos(rtp.y) * sin_p + ox;
  xyz.y = rtp.x * sin(rtp.y) * sin_p + oy;
  xyz.z = rtp.x * cos(rtp.z) + oz;
  return xyz;
}

/**
 *
 */
class AudioIndicator {
  
  Amplitude amp;
  int barTicks = 16;
  float barHeight = 100;
  float barWidth = 10;
  
  AudioIndicator(Amplitude amp) {
    this.amp = amp;
  }
  
  void display() {
    float level = this.amp.analyze();
    pushStyle();
    stroke(255);
    noFill();
    float h = barHeight / barTicks;
    float w = barWidth;
    rect(width-2*w, height - w - barHeight,w,barHeight); 
    for(int i = 1; i <= barTicks; i++) {
      noStroke();
      float amnt = pow((i+1)/float(barTicks), 2);
      if (level >= amnt) {
         fill(lerpColor(#1BE341,#E31B1B, amnt));
         rect(width-2*w, height - w - h*i,w,h);  
      }
    }
    popStyle();
  }
}

/**
 *
 */
void showFramerate() {
  pushStyle();
  fill(255);
  textSize(15);
  text(int(frameRate)+" FPS", 15, height - 30, width -15, height - 30);
  popStyle();
}
