public class BloonPropertyTable {
  private JSONObject data;
  
  private PImage sprite;
  
  public BloonPropertyTable(JSONObject data) {
    this.data = data;
    
    String spritePath = data.getString("sprite");
    this.sprite = loadImage(dataPath(spritePath));
  }
  
  public String getLayerName() {
    return data.getString("layerName"); 
  }
  
  public PImage getSprite() {
    return sprite;
  }
}
