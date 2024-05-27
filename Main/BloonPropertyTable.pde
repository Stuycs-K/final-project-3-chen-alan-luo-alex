public class BloonPropertyTable {
  private JSONObject data;
  
  private PImage sprite;
  
  public BloonPropertyTable(JSONObject data) {
    this.data = data;
    
    String spritePath = data.getString("sprite");
    this.sprite = loadImage(dataPath(spritePath));
    this.sprite.resize(this.sprite.width / 2, this.sprite.height / 2);
    
    this.sprite.loadPixels();
  }
  
  public JSONArray getChildren() {
    return data.getJSONArray("children");
  }
  
  public int getIntProperty(String keyName, int defaultValue) {
    if (data.isNull(keyName)) {
      return defaultValue; 
    }
    
    return data.getInt(keyName);
  }
  
  public float getFloatProperty(String keyName, float defaultValue) {
    if (data.isNull(keyName)) {
      return defaultValue; 
    }
    
    return data.getFloat(keyName);
  }
  
  public String getStringProperty(String keyName) {
    return data.getString(keyName);
  }
  
  public JSONObject getModifierArray() {
    return data.getJSONObject("modifiers"); 
  }
  
  public String getLayerName() {
    return data.getString("layerName"); 
  }
  
  public int getLayerId() {
    return data.getInt("id");
  }
  
  public PImage getSprite() {
    return sprite;
  }
}
