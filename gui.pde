/**
 *
 */
void createGUI() {
  gui = new ControlP5(this);
  gui.setAutoDraw(false);
  gui.addSlider("vertex_noise_amount")
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

void onVertexNoiseChange(float value) {
  mesh.setVertexNoiseAmount(value);
}
