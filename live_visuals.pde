import processing.sound.*;
import processing.video.*;
import themidibus.*;
import controlP5.*;

/** ------------------------------------------------------
 *  author:        Lorenzo Rivosecchi
 *  title:         live_visuals
 *  description:   A sketch to make interactive visuals
 *  version:       rebuild
 *  ------------------------------------------------------ */
 
JSONObject config;

boolean _fullscreen_ = false;
int _width_ = 500;
int _height_ = 500;

void settings() {
  loadConfig();
  if (_fullscreen_) { fullScreen(); }
  else { size(_width_, _height_); }
}

void setup() {

}

void draw() {

}
