public class BloonPropertyTable {
  private static final int SPRITE_SCALE = 4;
  
  private JSONObject data;
  
  private PImage sprite;
  
  private HashMap<String, PImage> spriteVariantMap;
  private HashMap<PImage, String> spriteVariantReverseMap;
  
  public BloonPropertyTable(JSONObject data) {
    this.data = data;
    
    String spritePath = data.getString("sprite");
    this.sprite = loadImage(dataPath(spritePath));
    this.sprite.resize(this.sprite.width / SPRITE_SCALE, this.sprite.height / SPRITE_SCALE);
    
    // Load sprite variants
    spriteVariantMap = new HashMap<String, PImage>();
    spriteVariantReverseMap = new HashMap<PImage, String>();
    
    JSONObject spriteVariants = data.getJSONObject("spriteVariants");
    
    Set<String> keySet = spriteVariants.keys();
    for (String keyName : keySet) {
      String path = spriteVariants.getString(keyName);
      PImage loadedImage = loadImage(dataPath(path));
      loadedImage.resize(loadedImage.width / SPRITE_SCALE, loadedImage.height / SPRITE_SCALE);
      
      spriteVariantMap.put(keyName, loadedImage);
      spriteVariantReverseMap.put(loadedImage, keyName);
    }
  }
  
  public JSONArray getChildren() {
    return data.getJSONArray("children");
  }
  
  public PImage getSpriteVariant(String variantName) {
    return spriteVariantMap.get(variantName); 
  }
  
  public String getSpriteVariantName(PImage image) {
    return spriteVariantReverseMap.get(image); 
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
