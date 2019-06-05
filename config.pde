void loadConfig() {
  try {
    config = loadJSONObject("config/settings.json");
    _fullscreen_ = config.getBoolean("fullscreen");
    _width_ = config.getInt("width");
    _height_ = config.getInt("height");
  } catch (Exception e) {
    println(e);
  }
}
