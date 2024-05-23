// SINGLETON
public class BloonPropertyLookup {
  private ArrayList<BloonPropertyTable> bloonPropertyTables;
  
  public BloonPropertyLookup() {
    JSONArray data = loadJSONArray("bloons.json");
    
    for (int i = 0; i < data.size(); i++) {
      JSONObject bloonData = data.getJSONObject(i);
      this.bloonPropertyTables.set(i, new BloonPropertyTable(bloonData));
    }
  }
  
  public BloonPropertyTable getProperties(String layerName) {
     for (BloonPropertyTable propertyTable: bloonPropertyTables) {
       if (propertyTable.getLayerName().equals(layerName)) {
         return propertyTable;
       }
     }
     
     return null;
  }
  
  public BloonPropertyTable getProperties(int id) {
    return bloonPropertyTables.get(id); 
  }
}
