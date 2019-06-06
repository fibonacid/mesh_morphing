/**
 *
 */
void createGUI() {
  gui = new ControlP5(this);
  gui.setAutoDraw(false);
  gui.addSlider("onVertexNoiseChange")
    .setLabel("VERTEX NOISE")
    .setRange(0.0, 1.0)
    .linebreak();
}

void onVertexNoiseChange(float value) {
  mesh.setVertexNoiseAmount(value);
}
