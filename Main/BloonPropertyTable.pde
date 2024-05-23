public class BloonPropertyTable {
  private JSONObject data;
  
  public BloonPropertyTable(JSONObject data) {
    this.data = data;
  }
  
  public String getLayerName() {
    return data.getString("layerName"); 
  }
}
