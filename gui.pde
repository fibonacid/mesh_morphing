/**
 *
 */
void createGUI() {
  gui = new ControlP5(this);
  gui.setAutoDraw(false);
  
  // Set gui colors
  gui.setColorBackground(0x66666666);
  gui.setColorForeground(0xBBBBBBBB);
  gui.setColorActive    (0xDDDDDDDD);
  gui.setFont(createFont("Menlo-Regular", 10));
  
  // Set style variables
  int marginLeft   = 20;
  int marginRight  = 20;
  int marginTop    = 20;
  int marginBottom = 20;
  int left   = marginLeft;
  int right  = width - marginRight;
  int top    = marginTop;
  int bottom = height - marginBottom;
  
  int[] sliderSize = {140, 14};
  int buttonSize = 14;
    
  myTextarea = gui.addTextarea("txt")
                  .setPosition(left+sliderSize[1]*4, bottom - 100)
                  .setSize(width-marginRight-marginLeft-4*sliderSize[1], 100)
                  .setFont(createFont("Menlo-Regular", 10))
                  .setLineHeight(14)
                  .setColor(color(200))
                  .setColorBackground(color(0, 100))
                  .setColorForeground(color(255, 100));
  ;

  console = gui.addConsole(myTextarea);
  console.pause();
  
  audioIndicator = gui.addSlider("audio_indicator")
    .setColorForeground(0xFF00FF00)
    .setColorActive    (0x00FF00FF)
    .setSize(sliderSize[1], 100)
    .setPosition(left, bottom -100)
    .setRange(0.,1.0)
    .setValue(0.5)
    .setLabelVisible(false) 
    .lock();
    
  audioSensitivitySlider = gui.addSlider("audio_sensitivity")
    //.setLabel("AUDIO SENSITIVITY")
    .setRange(0.0, 1.0)
    .setValue(1.0)
    .setLabelVisible(false) 
    .setSize(int(sliderSize[1]/2f), 100)
    .setPosition(left+sliderSize[1]+int(sliderSize[1]/2), bottom-100);  
  
  vertNoiseAmountSlider = gui.addSlider("vertex_noise_amount")
    .setLabel("VERTEX NOISE AMOUNT")
    .setRange(0.0, 1.0)
    .setValue(mesh.vertNoiseAmount.value)
    .setSize(sliderSize[0], sliderSize[1])
    .setPosition(left, top);
    
  vertNoiseSpeedSlider = gui.addSlider("vertex_noise_speed")
    .setLabel("VERTEX NOISE SPEED")
    .setRange(0.0, 1.0)
    .setValue(mesh.vertNoiseSpeed.value)
    .setSize(sliderSize[0], sliderSize[1])
    .setPosition(left, top+sliderSize[1]*2);
    
  fragNoiseAmountSlider = gui.addSlider("fragment_noise_amount")
    .setLabel("FRAGMENT NOISE AMOUNT")
    .setRange(0.0, 1.0)
    .setValue(mesh.vertNoiseAmount.value)
    .setSize(sliderSize[0], sliderSize[1])
    .setPosition(left, top+sliderSize[1]*4);
    
  fragNoiseSpeedSlider = gui.addSlider("fragment_noise_speed")
    .setLabel("FRAGMENT NOISE SPEED")
    .setRange(0.0, 1.0)
    .setValue(mesh.vertNoiseSpeed.value)
    .setSize(sliderSize[0], sliderSize[1])
    .setPosition(left, top+sliderSize[1]*6);
    
  ambientLightSlider = gui.addSlider("ambient_light")
    .setLabel("LIGHT INTENSITY")
    .setSize(sliderSize[0], sliderSize[1])
    .setPosition(left, top+sliderSize[1]*8)
    .setValue(0.25)
    .setRange(0.1, 1);
            
  meshModeRadio = gui.addRadio("mesh_mode")
    .setLabel("MESH MODE")
    .setPosition(left, top+sliderSize[1]*10)
    .setSize(sliderSize[1], sliderSize[1])
    .setItemsPerRow(2)
    .setSpacingColumn(70)
    .addItem("MATERIAL", Mesh.WITH_TEXTURE)
    .addItem("ABSTRACT", Mesh.NO_TEXTURE);
    
  colorWheel = gui.addColorWheel("tint")
    .setLabel("TINT")
    .setPosition(left, top+sliderSize[1] * 12);
       
  recordToggle = gui.addToggle("record")
    .setLabel("RECORD")
    .setState(false)
    .setPosition(right - buttonSize, top)
    .setSize(buttonSize, buttonSize);
    //.setColorBackground(color(255, 0, 0))
    //.setColorForeground(color(255, 0, 0));
    
  recordToggle.getCaptionLabel()
    .align(ControlP5.LEFT_OUTSIDE, CENTER)
    .getStyle().setPaddingLeft(-10);
  
  
}

/**
 * GUI event callback
 */
void controlEvent(ControlEvent event) {
   switch(event.name()) {
      case "vertex_noise_amount":
        mesh.setVertNoiseAmount(event.value(), 3000);
        break;
      case "vertex_noise_speed":
        mesh.setVertNoiseSpeed(event.value(), 3000);
        break;
      case "fragment_noise_amount":
        mesh.setFragNoiseAmount(event.value(), 3000);
        break;
      case "fragment_noise_speed":
        mesh.setFragNoiseSpeed(event.value(), 100000);
        break;
      case "audio_sensitivity":
        envf.setSensitivity(event.value());
        break;
      case "mesh_mode":
        try { mesh.setMode((int)event.value()); }
        catch (Exception e) { println(e); }
        break;
      case "ambient_light":
        lightIntensity.to(event.value(), 100000);
        break;
      case "tint":
        float r = colorWheel.r() / 255f;
        float g = colorWheel.g() / 255f;
        float b = colorWheel.b() / 255f;
        mesh.setFragTintColor(r,g,b, 5000);
        break;
      case "record":
        if (recordToggle.getState()) {
          startRecording();
        } else {
          stopRecording();
        }
        break;
   }
   if (event.name() != "audio_indicator") { // ignore audio indicator events
        println("[GUI]\t"+event.name(),"=",event.value()); 
   }
}
