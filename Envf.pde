class EnvelopeFollower {

  Amplitude rms;
  float smoothingFactor = 0.25;
  private float value;
  private float record = 0.0;
  
  EnvelopeFollower(PApplet parent, AudioIn input) {
    // Create a new Amplitude analyzer
    rms = new Amplitude(parent);
    // Patch the input to the volume analyzer
    rms.input(input);
  }
  
  float getValue() {
    float amp = rms.analyze();
    if (amp > record) record = amp;
    value += (amp  - value) * smoothingFactor;
    return map(value, 0, record, 0, 1);
  } 
}
