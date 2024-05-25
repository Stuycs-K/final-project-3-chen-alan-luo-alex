static final int NULL_INT = Integer.MIN_VALUE;
static final float NULL_FLOAT = Float.MIN_VALUE;

public class BloonPropertyTable {
  private JSONObject data;
  
  private PImage sprite;
  
  public BloonPropertyTable(JSONObject data) {
    this.data = data;
    
    String spritePath = data.getString("sprite");
    this.sprite = loadImage(dataPath(spritePath));
  }
  
  public JSONArray getChildren() {
    return data.getJSONArray("children");
  }
  
  public int getIntProperty(String keyName) {
    try {
      return data.getInt(keyName);
    } catch (Exception exception) {
      return NULL_INT;
    }
  }
  
  public float getFloatProperty(String keyName) {
    try {
      return data.getFloat(keyName);
    } catch (Exception exception) {
      return NULL_FLOAT;
    }
  }
  
  public String getStringProperty(String keyName) {
    return data.getString(keyName);
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
