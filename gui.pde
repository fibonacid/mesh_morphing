/**
 *
 */
void createGUI() {
  gui = new ControlP5(this);
  gui.setAutoDraw(false);
  gui.addSlider("vertex_noise_amount")
  audioIndicator = gui.addSlider("audio_indicator")
    .setColorForeground(0xFF00FF00)
    .setColorActive    (0x00FF00FF)
    .setSize(sliderSize[1], 100)
    .setPosition(left, bottom -100)
    .setRange(0.,1.0)
    .setValue(0.5)
    .setLabelVisible(false) 
    .lock();
    .setLabel("VERTEX NOISE AMOUNT")
    .setRange(0.0, 1.0)
    .linebreak();
  gui.addSlider("vertex_noise_speed")
    .setLabel("VERTEX NOISE SPEED")
    .setRange(0.0, 1.0)
    .linebreak();
  gui.addSlider("audio_sensitivity")
    .setLabel("AUDIO SENSITIVITY")
    .setRange(0.0, 1.0)
    .linebreak();
}

void vertex_noise_amount (float value) {
  mesh.setVertexNoiseAmount(value, 3000);
}

void vertex_noise_speed(float value) {
  mesh.setVertexNoiseSpeed(value, 3000); 
}

void audio_sensitivity(float value) {
  envf.setSensitivity(value);
}
