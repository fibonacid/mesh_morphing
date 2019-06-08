void loadConfig() {
  try {
    // Load Configuration Data
    config = loadJSONObject("config/settings.json");    
    // Override session variables with config variables
    _fullscreen_ = config.getBoolean("fullscreen");
    _width_ = config.getInt("width");
    _height_ = config.getInt("height");
    _eco_ = config.getBoolean("eco");
    _texture_ = config.getString("texture");
    println("config file loaded succesfully");
  } catch (NullPointerException e) {
    JSONObject json = freshConfig();
    saveJSONObject(json, "config/settings.json");  
    println("Created new config file with default values");
    println("find me in config/settings.json");
  } catch (Exception e) {
    e.printStackTrace();
  }
}

JSONObject freshConfig() {
    JSONObject json = new JSONObject();
    json.setBoolean("fullscreen", _fullscreen_);
    json.setInt("width", _width_);
    json.setInt("height", _height_);
    json.setBoolean("eco", _eco_);
    json.setString("texture", DEFAULT_TEXTURE);
    saveJSONObject(json, "config/settings.json");  
    return json;
}
