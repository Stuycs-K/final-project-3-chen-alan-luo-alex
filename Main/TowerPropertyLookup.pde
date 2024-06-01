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
  private PImage baseSprite;
  
  private TowerUpgradeInformation upgrades;
  
  public TowerPropertyTable(JSONObject towerDefinitions) {
    JSONObject baseProperties = towerDefinitions.getJSONObject("base");
    this.baseProperties = baseProperties;
    this.upgrades = new TowerUpgradeInformation(towerDefinitions.getJSONObject("upgrades"));
    this.baseSprite = loadImage("images/" + baseProperties.getString("sprite"));
  }
  
  public int getBaseCost() {
    return baseProperties.getInt("cost");
  }
  
  public JSONObject getBaseProperties() {
    return baseProperties;
  }
  
  public PImage getBaseSprite() {
    return baseSprite;
  }
  
  public TowerUpgradeInformation getUpgradeInformation() {
    return upgrades;
  }
}

private class TowerUpgradeInformation {
  private ArrayList<ArrayList<TowerUpgrade>> upgradePaths;
  
  public TowerUpgradeInformation(JSONObject upgrades) {
    upgradePaths = new ArrayList<ArrayList<TowerUpgrade>>();
    
    for (String upgradePathKey : (Set<String>) upgrades.keys()) {
      JSONArray upgradeArray = upgrades.getJSONArray(upgradePathKey);
      
      ArrayList<TowerUpgrade> upgradeArrayList = new ArrayList<TowerUpgrade>();
      
      for (int i = 0; i < upgradeArray.size(); i++) {
        JSONObject upgradeData = upgradeArray.getJSONObject(i);
        
        TowerUpgrade towerUpgrade = new TowerUpgrade(upgradeData);
        upgradeArrayList.add(towerUpgrade);
      }
      
      int index = Integer.parseInt(upgradePathKey);
      upgradePaths.add(upgradeArrayList);
    }
  }
  
  // NOTE: Path 1 has ID 0, and path 2 has ID 1 !!!
  public ArrayList<TowerUpgrade> getUpgradePath(int pathId) {
    return upgradePaths.get(pathId); 
  }
  
  public TowerUpgrade getFirstUpgrade(int pathId) {
    return getNextUpgrade(pathId, -1);
  }
  
  // Have to check if the next upgrade is null with this one
  public TowerUpgrade getNextUpgrade(int pathId, int currentUpgradeId) {
    int nextUpgradeId = currentUpgradeId + 1;
    ArrayList<TowerUpgrade> upgradePathList = getUpgradePath(pathId);
    
    if (upgradePathList.size() <= nextUpgradeId) {
      return null;
    }
    
    return upgradePathList.get(nextUpgradeId);
  }
}

private class TowerUpgrade {
  private JSONObject upgradeData;
  private PImage upgradeImage;
  
  public TowerUpgrade(JSONObject upgradeData) {
    this.upgradeData = upgradeData;
    
    this.upgradeImage = loadImage(dataPath("images/" + upgradeData.getString("upgradeImage")));
  }
  
  public void applyUpgrade(Tower tower) {
    
  }
  
  public PImage getUpgradeImage() {
    return upgradeImage;
  }
  
  public int getUpgradeCost() {
    return upgradeData.getInt("cost");
  }
}
