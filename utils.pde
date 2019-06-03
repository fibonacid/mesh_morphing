class Line implements Runnable {
  
  final int SLEEP_TIME = 100;
  float timestamp;
  float destination;
  float value;
  float startValue;
  float duration;
  Thread ease = new Thread(this);
  
  Line() {
    this.value = 0;
    ease.start();
  }
  
  void to(float destination, float duration) {
    timestamp = millis();
    this.destination = destination;
    this.duration = duration;
    println("============");
    println("value =", value);
    println("============");
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
            float angle = destination / duration;
            float output = value + angle * time;
            println( //<>//
              "time:",time,
              "output:", output,
              "angle:",angle,
              "duration:",duration,
              "destination:",destination);
            //noisySphere.setNoiseAmount(value);
          } else {
            
          }
          ease.sleep(SLEEP_TIME);
        } catch (Exception e) {
          
        }
     } 
  }
}
