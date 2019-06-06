/**
 *
 */
void createGUI() {
  gui = new ControlP5(this);
  gui.setAutoDraw(false);
  gui.addSlider("onHelloWorldChange")
    .setLabel("Hello World")
    .setRange(0.0, 1.0)
    .linebreak();
}

void onHelloWorldChange(float value) {
  println("Hello World");
}
