class Mesh {

  private PShape shape;                
  private final int SD_VERTEX_AMOUNT = 30;      // Number of vertexes for a standard definition shape 
  private final int HD_VERTEX_AMOUNT = 150;     // Number of vertexes for a high definition shape 
  
  private PVector position;            // Position of the shape
  private PVector rotation;            // Rotation of the shape
  private PVector rotationSpeed;       // Speed rotation of the shape         
  private final float SIZE = width/4;

  private PImage textureImage;  // Texture that will be attached to pshape by default 
  
  /* The following shader objects are basically just customized versions of the shaders that processing use.                      *
   * Both share the same code to perform vertex displacement, the TEXLIGHT_SHADER wraps the object with a given texture,          *
   * and the LIGHT_SHADER doens't support a texture but can color itself passing its vertex position into a perlin noise function */
  private final PShader TEXLIGHT_SHADER = loadShader("shaders/TexLightFrag.glsl", "shaders/TexLightVert.glsl");
  private final PShader LIGHT_SHADER = loadShader("shaders/LightFrag.glsl", "shaders/LightVert.glsl");
  
  private PShader currentShader; // Pointer to the currently active shader

  /* Constants to request a specific configuration of this class *
   * @see setMode(int mode)                                      */
  final static int WITH_TEXTURE = 1;
  final static int NO_TEXTURE   = 2;

  /* Controllable parameters of the class *
   * @see Line class (utils tab)          */
  private final Line vertNoiseAmount = new Line(1.0);   // amount of vertex displacement
  private final Line vertNoiseSpeed  = new Line(0.5);   // frequency of the vertex displacement
  private final Line fragNoiseAmount = new Line(1.0);   // sharpness of the noise texture
  private final Line fragNoiseSpeed  = new Line(0.5);   // frequency of the noise texture

  /**
   * Constructor of the class
   */
  Mesh() {
    if (_eco_) { 
      sphereDetail(SD_VERTEX_AMOUNT);
    } else { 
       // if resources are low shape should have less vertexes
      sphereDetail(HD_VERTEX_AMOUNT);
    }   
    
    // Construct a Shape
    shape = createShape(SPHERE, SIZE);
    
    // Apply Texture
    textureImage = loadImage("textures/"+_texture_);
    if (textureImage == null) {
      textureImage = loadImage("textures/"+DEFAULT_TEXTURE);
      // Add messages to queue
      consoleQueue.append("File "+_texture_+" doesn't exist.");
      consoleQueue.append("Texture File reverted to default ("+DEFAULT_TEXTURE+")\n");
    }
    shape.setTexture(textureImage);
    shape.setStroke(false);
  
    // Set motion coordinates
    position = new PVector(width/2, height/2, 0);
    rotation = new PVector(0, 0, 0);
    rotationSpeed = new PVector(random(0, PI/1024), random(0, PI/1024), random(0, PI/1024));
    
    // Set initial shader to use
    currentShader = LIGHT_SHADER;
  }
  
  /**
   * Apply some kind of transformation on the class data
   */
  void update() {
    // Set Shader Uniforms
    currentShader.set("u_time", sceneClock);                        
    currentShader.set("u_vert_noise_amount", vertNoiseAmount.value);      
    currentShader.set("u_vert_noise_speed", vertNoiseSpeed.value);
    if (currentShader.equals(LIGHT_SHADER)) {
      currentShader.set("u_frag_noise_amount", fragNoiseAmount.value);
      currentShader.set("u_frag_noise_speed", fragNoiseSpeed.value);
    }
  }
  
  /**
   * Rotate shape by an amount equal to rotationSpeed
   */
  void rotate() {
    rotation.add(rotationSpeed);
  }
  
  /**
   * Draw shape
   */
  void display() {     
    
    // Change rendering shader
    shader(currentShader);

    pushMatrix();
    
    translate(position.x, position.y, position.z);
    rotateX(rotation.x);
    rotateY(rotation.y);
    rotateZ(rotation.z);
    
    // Draw shape
    shape(shape);
    
    popMatrix();
    
    // Bring back default rendering shader
    resetShader();
  }

  /**
   * Use this function to set a specific configuration depending on the current mode
   */
  void setMode(int mode) {
    switch(mode) {
    case WITH_TEXTURE:
      currentShader = TEXLIGHT_SHADER;  // Use shader with texture and light support
      break;
    case NO_TEXTURE:
      currentShader = LIGHT_SHADER;     // Use shader with only light support
      break;
    }
  }
  
  /* ----------------------------------------------------------------------- *
   *                          SETTERS AND GETTERS                            *
   * ----------------------------------------------------------------------- */

  void setVertNoiseAmount(float value, float time) { vertNoiseAmount.to(value, time); }

  void setVertNoiseSpeed(float value, float time)  { 
    vertNoiseSpeed.to(value, time);  
  }

  void setFragNoiseAmount(float value, float time) {
    if (currentShader.equals(LIGHT_SHADER)) {
      fragNoiseAmount.to(value, time); 
    } else {
      println("This parameter doens't apply to the current shader");
      println("Hit ABSTRACT to see results");
    }
  }

  void setFragNoiseSpeed(float value, float time)  { 
    if (currentShader.equals(LIGHT_SHADER)) {
      fragNoiseSpeed.to(value, time); 
    } else {
      println("This parameter doens't apply to the current shader");
      println("Hit ABSTRACT to see results");
    } 
  }

  void scale(float value) { currentShader.set("u_scale", value); }
}
