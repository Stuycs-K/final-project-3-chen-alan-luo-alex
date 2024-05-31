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
  
  public TowerPropertyTable getTowerProperties(String towerName) {
    return towerPropertyMap.get(towerName);
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
  private ArrayList<LinkedList<TowerUpgrade>> upgradePaths;
  
  public TowerUpgradeInformation(JSONObject upgrades) {
    upgradePaths = new ArrayList<LinkedList<TowerUpgrade>>();
    
    for (String upgradePathKey : (Set<String>) upgrades.keys()) {
      JSONArray upgradeArray = upgrades.getJSONArray(upgradePathKey);
      
      LinkedList<TowerUpgrade> upgradeLinkedList = new LinkedList<TowerUpgrade>();
      
      for (int i = 0; i < upgradeArray.size(); i++) {
        JSONObject upgradeData = upgradeArray.getJSONObject(i);
        
        TowerUpgrade towerUpgrade = new TowerUpgrade(upgradeData);
        upgradeLinkedList.add(towerUpgrade);
      }
      
      int index = Integer.parseInt(upgradePathKey);
      upgradePaths.set(index, upgradeLinkedList);
    }
  }
  
  public LinkedList<TowerUpgrade> getUpgradePath(int pathId) {
    return upgradePaths.get(pathId); 
  }
}

private class TowerUpgrade {
  public TowerUpgrade(JSONObject upgradeDefinition) {
    
  }
  
  public void applyUpgrade(Tower tower) {
    
  }
}
