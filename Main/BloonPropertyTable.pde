public class BloonPropertyTable {
  private JSONObject data;
  
  private PImage sprite;
  
  private HashMap<String, PImage> spriteVariantMap;
  
  public BloonPropertyTable(JSONObject data) {
    this.data = data;
    
    String spritePath = data.getString("sprite");
    this.sprite = loadImage(dataPath(spritePath));
    this.sprite.resize(this.sprite.width / 2, this.sprite.height / 2);
    
    // Load sprite variants
    spriteVariantMap = new HashMap<String, PImage>();
    JSONObject spriteVariants = data.getJSONObject("spriteVariants");
    
    Set<String> keySet = spriteVariants.keys();
    for (String keyName : keySet) {
      String path = spriteVariants.getString(keyName);
      PImage loadedImage = loadImage(dataPath(path));
      loadedImage.resize(loadedImage.width / 3, loadedImage.height / 3);
      spriteVariantMap.put(keyName, loadedImage);
    }
  }
  
  public JSONArray getChildren() {
    return data.getJSONArray("children");
  }
  
  public PImage getSpriteVariant(String variantName) {
    return spriteVariantMap.get(variantName); 
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
