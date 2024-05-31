public class TowerPropertyLookup {
  private HashMap<String, TowerPropertyTable> towerPropertyMap;
  
  public TowerPropertyLookup() {
    towerPropertyMap = new HashMap<String, TowerPropertyTable>(); 
    
    JSONObject data = loadJSONObject("towers.json");
    Set<String> towerNames = data.keys();
    for (String towerName : towerNames) {
      JSONObject towerProperties = data.getJSONObject(towerName);
      
      towerPropertyMap.put(towerName, new TowerPropertyTable(towerProperties));
    }
  }
}

private class TowerPropertyTable {
  private JSONObject baseProperties;
  private int baseCost;
  
  private TowerUpgradeInformation upgrades;
  
  public TowerPropertyTable(JSONObject towerDefinitions) {
    JSONObject baseProperties = towerDefinitions.getJSONObject("base");
    this.baseProperties = baseProperties;
    this.upgrades = new TowerUpgradeInformation(towerDefinitions.getJSONObject("upgrades"));
  }
  
  public int getBaseCost() {
    return baseProperties.getInt("cost");
  }
}

private class TowerUpgradeInformation {
  
  
  public TowerUpgradeInformation(JSONObject upgrades) {
    
  }
}
