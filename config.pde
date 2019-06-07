void loadConfig() {
  try {
    // Load Configuration Data
    config = loadJSONObject("config/settings.json");
    
    // Override session variables with config variables
    _fullscreen_ = config.getBoolean("fullscreen");
    _width_ = config.getInt("width");
    _height_ = config.getInt("height");
    _eco_ = config.getBoolean("eco");
  } catch (NullPointerException e) {
    //JSONObject _settings = new JSONObject();
    //_settings.add
    
  } catch (Exception e) {
    e.printStackTrace();
  }
}
