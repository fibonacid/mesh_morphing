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
            value = value + angle * time; //<>//
          } else {
            
          }
          ease.sleep(SLEEP_TIME);
        } catch (Exception e) {
          
        }
     } 
  }
}
