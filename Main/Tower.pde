public class Tower{
  public int x;
  public int y; 
  public int radius;
  public int range;
  public int fireRate; 
  public int damage;
  public int attackSpeed;
  public int upgradeLevel;
  public int attackCooldown;
  public ArrayList<Projectile> projectiles;
  private TowerTargetFilter targetFilter;
  public ArrayList<PImage> sprites;
  public int path;
  public float angle;
  public int hitBoxX;
  public int hitBoxY;
  public int cost;
  
  private int totalCurrencySpent;
  private PImage sprite;
  public String towerName;
  
  public HashMap<String, TowerAction> actionMap;
  public HashMap<String, ProjectileData> projectileMap;
  public TowerUpgradeManager upgrades;
  
  public Tower(int x, int y, int range, int fireRate, int damage, int attackSpeed, int radius, int cost){
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.range = range;
    this.fireRate = fireRate;
    this.damage = damage;
    this.attackSpeed = attackSpeed;
    this.upgradeLevel = 0;
    this.attackCooldown = 0;
    this.projectiles = new ArrayList<Projectile>();
    this.targetFilter = new TowerTargetFilter();
    this.angle = PI;
    this.cost = cost;
    
    this.actionMap = new HashMap<String, TowerAction>();
  }
  
  public Tower(String towerName, int x, int y) {
    this.towerName = towerName;
    this.x = x;
    this.y = y;
    
    this.targetFilter = new TowerTargetFilter();
    this.angle = PI;
    
    // Only set the base properties
    TowerPropertyTable properties = towerPropertyLookup.getTowerProperties(towerName);
    JSONObject baseProperties = properties.getBaseProperties();
    this.range = baseProperties.getInt("range");
    
    this.totalCurrencySpent = properties.getBaseCost();
    
    // First, load the base tower sprite
    this.sprite = properties.getBaseSprite();
    
    // Setup actions
    this.actionMap = new HashMap<String, TowerAction>();
    
    JSONObject actionData = baseProperties.getJSONObject("actions");
    for (String actionName : (Set<String>) actionData.keys()) {
      JSONObject actionDefinition = actionData.getJSONObject(actionName);
      
      String actionClass = actionDefinition.getString("type");
      TowerAction actionObject = null;
      
      // Create base actions
      switch (actionClass) {
        case "PROJECTILE":
          actionObject = new ProjectileSpawnAction(actionDefinition);
          break;
        default:
          actionObject = new TowerAction(actionDefinition);
      }
      
      this.actionMap.put(actionName, actionObject);
    }
    
    // Setup projectiles
    this.projectileMap = new HashMap<String, ProjectileData>();
    
    JSONObject projectileData = baseProperties.getJSONObject("projectiles");
    for (String projectileName : (Set<String>) projectileData.keys()) {
      JSONObject projectileDefinition = projectileData.getJSONObject(projectileName);
      
      ProjectileData projectileDataObject = new ProjectileData(projectileDefinition);
      
      this.projectileMap.put(projectileName, projectileDataObject);
    }
    
    this.projectiles = new ArrayList<Projectile>();
    
    this.upgrades = new TowerUpgradeManager(this);
  }
  
  // Sets range and sprite and that's it
  public void setPropertiesFromUpgrade(TowerUpgrade upgrade) {
    this.range = readInt(upgrade.getChanges(), "range", this.range);
    
    PImage newSprite = upgrade.getSprite();

    if (newSprite != null) {
      this.sprite = newSprite;
    }
  }
  
  public void step(ArrayList<Bloon> bloons) {
    for (TowerAction action : actionMap.values()) {
      if (!action.checkCooldown()) {
        continue;
      }
      
      action.performAction(this, bloons);
    }
  }
  
  public void lookAt(PVector position) {
    lookAt(position.x, position.y);
  }
  
  public void lookAt(float targetX, float targetY) {
    angle = atan2(targetY - y, targetX - x);
  }
  
  // The base getTargetPositions only gets the position of the first Bloon in range
  public ArrayList<PVector> getTargetPositions(ArrayList<Bloon> bloons) {
    ArrayList<PVector> results = new ArrayList<PVector>();
    
    for (Bloon targetBloon : bloons) {
      if (!targetFilter.canAttack(targetBloon)) {
        continue;
      }
      
      float distance = dist(x, y, targetBloon.position.x, targetBloon.position.y);
      if (distance <= range) {
        results.add(targetBloon.position.copy());
        break;
      }
    }
    
    return results;
  }
  
  public boolean upgrade(int pathId) {
    return upgrades.upgrade(pathId);
  }
  
  public void sellTower(){
     game.getCurrencyManager().rewardCurrency(getSellPrice());
     game.towers.remove(this);
  }
  
  public void increaseCurrencySpent(int amount) {
     totalCurrencySpent += amount;
  }
  
  public float getSellPrice(){
    return totalCurrencySpent * 0.8;
  }

  public void draw(){
    pushMatrix();
    translate(x, y);
    rotate(angle + HALF_PI);
    imageMode(CENTER);
    image(sprite, 0, 0);
    popMatrix();
    
    for(Projectile projectile : projectiles){
      projectile.drawProjectile();
    }
  }
  
  public int getCost(){
    return 0;
  }
  
  public int getTowerX(){
    return x;
    
  }
  
  public int getTowerY(){
    return y;
  }
  
  public void setHitBox(int hitBoxX, int hitBoxY){
    
  }
  
}

public class TowerUpgradeManager {
  private static final int MAX_SECONDARY_UPGRADES = 1; // Maximum of 2 upgrades (0 is the first ugprade, 1 is the second)
  private static final int MAX_PATHS_UPGRADED = 2; // Maximum of 2 upgrade paths upgraded
  
  private Tower tower;
  private ArrayList<Integer> pathUpgradeLevelList;
  
  private int mainUpgradePath; // The upgrade path we've put more than 2 upgrades in
  private int pathsUpgraded;
  
  private TowerUpgradeInformation upgradeInformation;
  
  public TowerUpgradeManager(Tower tower) {
    this.tower = tower;
    this.pathUpgradeLevelList = new ArrayList<Integer>();
    
    this.mainUpgradePath = -1;
    this.pathsUpgraded = 0;
    
    this.upgradeInformation = towerPropertyLookup.getTowerProperties(tower.towerName).getUpgradeInformation();
    
    // Set all upgrade levels to -1, which is the base upgrade
    for (int i = 0; i < upgradeInformation.getNumberOfUpgradePaths(); i++) {
      pathUpgradeLevelList.add(-1); 
    }
  }
  
  public TowerUpgradeInformation getUpgradeInformation() {
    return upgradeInformation;
  }
  
  // Returns stuff like "2-0" or "3-2"
  public String formatUpgradeLevels() {
    String result = "";
    
    for (int upgradeLevel : pathUpgradeLevelList) {
      result += upgradeLevel + "-";
    }
    
    return result.substring(0, result.length() - 1);
  }
  
  public boolean upgrade(int pathId) {
    int currentUpgradeLevel = pathUpgradeLevelList.get(pathId);
    
    // Can't upgrade a third path, as we've already upgraded two
    if (currentUpgradeLevel == -1 && pathsUpgraded == MAX_PATHS_UPGRADED) {
      return false;
    }
    
    // Can't upgrade the secondary upgrade path anymore, as we've already upgraded it twice
    if (mainUpgradePath != -1 && mainUpgradePath != pathId && currentUpgradeLevel == MAX_SECONDARY_UPGRADES) {
      return false;
    }
    
    TowerUpgrade upgrade = upgradeInformation.getNextUpgrade(pathId, currentUpgradeLevel);
    if (upgrade == null) {
      return false;
    }
    
    // First upgrade in this path, so increase paths upgraded
    if (currentUpgradeLevel == -1) {
      pathsUpgraded++; 
    }
    
    // We're about to upgrade this path for the third time, so set it as our main path
    if (currentUpgradeLevel == MAX_SECONDARY_UPGRADES) {
      mainUpgradePath = pathId;
    }
    
    // Increment this upgrade path level
    pathUpgradeLevelList.set(pathId, currentUpgradeLevel + 1);
    
    // Set range and sprite
    tower.setPropertiesFromUpgrade(upgrade);
    
    JSONObject upgradeChanges = upgrade.getChanges();
    
    // Now update actions
    JSONObject actionChanges = upgradeChanges.getJSONObject("actions");
    if (actionChanges != null) {
      for (String actionName : (Set<String>) actionChanges.keys()) {
        TowerAction action = tower.actionMap.get(actionName);
        action.setProperties(actionChanges.getJSONObject(actionName));
      }
    }

    
    // And then projectiles
    JSONObject projectileChanges = upgradeChanges.getJSONObject("projectiles");
    
    if (projectileChanges != null) {
      for (String projectileName : (Set<String>) projectileChanges.keys()) {
        ProjectileData projectile = tower.projectileMap.get(projectileName);
        projectile.updateProperties(projectileChanges.getJSONObject(projectileName));
      }
    }
    
    return true;
  }
  
  // NOTE: Some values in the ArrayList will be null!
  // For GUI, mainly
  public ArrayList<TowerUpgrade> getNextUpgrades() {
    ArrayList<TowerUpgrade> upgradesList = new ArrayList<TowerUpgrade>();
    
    for (int pathId = 0; pathId < upgradeInformation.getNumberOfUpgradePaths(); pathId++) {
      int currentUpgradeLevel = pathUpgradeLevelList.get(pathId);
      
      upgradesList.add(upgradeInformation.getNextUpgrade(pathId, currentUpgradeLevel));
    }
    
    return upgradesList;
  }
}

//---------------------------------------------------------------------------------------------------------------
// GENERIC ACTION TYPES
// Actions with more specific functionality should be placed in their relevant tower tab and extend one of these
//---------------------------------------------------------------------------------------------------------------
public class TowerAction {
  private int cooldownTicks; // In ticks
  private int currentCooldown;
  private String actionType;
  
  public TowerAction(JSONObject actionData) {
    setProperties(actionData);
    this.currentCooldown = this.cooldownTicks;
  }
  
  public void setProperties(JSONObject actionData) {
    if (!actionData.isNull("cooldown")) {
      float cooldownSeconds = actionData.getFloat("cooldown");
      this.cooldownTicks = int(cooldownSeconds * frameRate);
    }

    this.actionType = readString(actionData, "type", this.actionType);
  }
  
  // Called every tick
  public boolean checkCooldown() {
    if (currentCooldown >= cooldownTicks) {
      return true; 
    }
    
    currentCooldown++;
    return false;
  }
  
  public void resetCooldown() {
    currentCooldown = 0;
  }
  
  public String getActionType() {
    return actionType;
  }
  
  public void performAction(Tower tower, ArrayList<Bloon> bloons) {
    return;
  }
}

public class ProjectileSpawnAction extends TowerAction {
  private String projectileName;
  
  public ProjectileSpawnAction(JSONObject actionData) {
    super(actionData);
  }
  
  public void setProperties(JSONObject actionData) {
    super.setProperties(actionData);
    
    this.projectileName = readString(actionData, "projectile", this.projectileName); 
  }
  
  public String getSpawnedProjectileName() {
    return projectileName;
  }
  
  public void performAction(Tower tower, ArrayList<Bloon> bloons) {
    resetCooldown();
    
    ArrayList<PVector> targetPositions = tower.getTargetPositions(bloons);

    ProjectileData data = tower.projectileMap.get(getSpawnedProjectileName());
    
    for (PVector position : targetPositions) {
      tower.projectiles.add(new Projectile(new PVector(tower.x, tower.y), new PVector(position.x, position.y), data));
    }
    
    if (targetPositions.size() > 0) {
      tower.lookAt(targetPositions.get(targetPositions.size() - 1));
    }

  }
}
