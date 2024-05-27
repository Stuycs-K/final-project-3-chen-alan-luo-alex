// Parses and caches all information about bloons (and their modifiers)
public class BloonPropertyLookup {
  private ArrayList<BloonPropertyTable> bloonPropertyTables;
  
  private ArrayList<JSONObject> bloonModifierTables;
  
  public BloonPropertyLookup() {
    // Populate bloon properties
    bloonPropertyTables = new ArrayList<BloonPropertyTable>();
    
    JSONArray data = loadJSONArray("bloons.json");
    
    for (int i = 0; i < data.size(); i++) {
      JSONObject bloonData = data.getJSONObject(i);
      this.bloonPropertyTables.add(new BloonPropertyTable(bloonData));
    }
    
    // Populate bloon modifiers
    bloonModifierTables = new ArrayList<JSONObject>();
    JSONArray modifierData = loadJSONArray("bloonModifiers.json");
    
    for (int i = 0; i < modifierData.size(); i++) {
      JSONObject modifier = modifierData.getJSONObject(i);
      this.bloonModifierTables.add(modifier);
    }
  }
  
  public String getLayerNameFromId(int id) {
    return bloonPropertyTables.get(id).getLayerName();
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
  
  public JSONObject getModifier(String modifierName) {
    for (JSONObject modifier : bloonModifierTables) {
      if (modifier.getString("name").equals(modifierName)) {
        return modifier;
      }
    }

     return null;
  }
}
