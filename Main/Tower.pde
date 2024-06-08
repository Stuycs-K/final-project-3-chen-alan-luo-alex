private int readIntDiff(JSONObject object, String keyName, int originalValue) {
  if (object.isNull(keyName)) {
    return originalValue;
  }
  
  int test = readInt(object, keyName, Integer.MIN_VALUE);

  // This is a number we are SETTING a property to
  // Otherwise, it's a string and we're ADDING to the property
  if (test != Integer.MIN_VALUE) {
    return test;
  }
  
  String[] diffInstructions = readString(object, keyName, "").split(" ");

  String operation = diffInstructions[0];
  String value = diffInstructions[1];
  
  switch (operation) {
    case "+":
      return originalValue + Integer.parseInt(value);
    case "-":
      return originalValue - Integer.parseInt(value);
      
    // For multiplication and division, read the value as a float
    case "*":
      return int(originalValue * Float.parseFloat(value));
    case "/":
      return int(originalValue / Float.parseFloat(value));
      
    default:
      return originalValue + Integer.parseInt(value);
  }
}

private float readFloatDiff(JSONObject object, String keyName, float originalValue) {
  if (object.isNull(keyName)) {
    return originalValue;
  }
  
  float test = readFloat(object, keyName, Float.MIN_VALUE);
  
  // This is a number we are SETTING a property to
  // Otherwise, it's a string and we're ADDING to the property
  if (test != Float.MIN_VALUE) {
    return test;
  }
  
  String[] diffInstructions = readString(object, keyName, "").split(" ");
  
  String operation = diffInstructions[0];
  float value = Float.parseFloat(diffInstructions[1]);
  
  switch (operation) {
    case "+":
      return originalValue + value;
    case "-":
      return originalValue - value;
      
    // For multiplication and division, read the value as a float
    case "*":
      return originalValue * value;
    case "/":
      return originalValue / value;
      
    default:
      return originalValue + value;
  }
}

private TowerAction createAction(String actionClass, JSONObject actionDefinition) {
  TowerAction action ;
 
  switch (actionClass) {
    case "NULL":
      return null;
    case "PROJECTILE":
      action = new ProjectileSpawnAction(actionDefinition);
      break;
    case "MULTI_PROJECTILE":
      action = new MultiProjectileSpawnAction(actionDefinition);
      break;
    default:
      action = new TowerAction(actionDefinition);
  }
  
  return action;
}

public class Tower{
  public static final float TOWER_FOOTPRINT_SIZE = 15;
  
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
  public TowerTargetFilter targetFilter;
  public ArrayList<PImage> sprites;
  public int path;
  public float angle;
  public int hitBoxX;
  public int hitBoxY;
  public int cost;
  
  public float footprint; // Hitbox radius (hitboxes are circles)
  
  private int totalCurrencySpent;
  public PImage sprite;
  public String towerName;
  
  public HashMap<String, TowerAction> actionMap;
  public HashMap<String, ProjectileData> projectileMap;
  public TowerUpgradeManager upgrades;
  
  public Tower(String towerName, int x, int y) {
    this.towerName = towerName;
    this.x = x;
    this.y = y;
    this.footprint = TOWER_FOOTPRINT_SIZE;
    
    this.targetFilter = new TowerTargetFilter(this);
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
      TowerAction actionObject = createAction(actionClass, actionDefinition);
      
      this.actionMap.put(actionName, actionObject);
    }
    
    // Setup projectiles
    this.projectileMap = new HashMap<String, ProjectileData>();
    
    JSONObject projectileData = baseProperties.getJSONObject("projectiles");
    for (String projectileName : (Set<String>) projectileData.keys()) {
      JSONObject projectileDefinition = projectileData.getJSONObject(projectileName);
      
      ProjectileData projectileDataObject = createProjectileData(projectileDefinition);
      
      this.projectileMap.put(projectileName, projectileDataObject);
    }
    
    this.projectiles = new ArrayList<Projectile>();
    
    this.upgrades = new TowerUpgradeManager(this);
  }
  
  public TowerUpgrade getCurrentUpgrade(int pathId){
    int currentLevel = upgrades.getCurrentLevel(pathId)-1;
    return upgrades.getUpgradeInformation().getNextUpgrade(pathId,currentLevel);
  
  }
  
  public PImage getPathUpgradeImage(int pathId){
    TowerUpgrade currentUpgrade = getCurrentUpgrade(pathId);
    if(currentUpgrade!=null){
      return currentUpgrade.getSprite();
    }
    return this.sprite;
  }
  
  public PImage getSprite(){
    return sprite;
  }
  
  // Sets range and camo detection
  public void setPropertiesFromUpgrade(TowerUpgrade upgrade) {
    JSONObject changes = upgrade.getChanges();
    
    this.range = readIntDiff(changes, "range", this.range);
    
    boolean detectCamo = readBoolean(changes, "detectCamo", targetFilter.canDetectCamo());
    targetFilter.setCamoDetection(detectCamo);
  }
  
  public void setSpriteFromUpgrade(TowerUpgrade upgrade) {
    PImage newSprite = upgrade.getSprite();

    if (newSprite != null) {
      this.sprite = newSprite;
    }
  }
  
  public void step(ArrayList<Bloon> bloons) {
    ArrayList<Bloon> targetBloons = getTargetBloons(bloons);
    
    for (TowerAction action : actionMap.values()) {
      if (!action.checkCooldown()) {
        continue;
      }
      
      if (!action.shouldPerformAction(targetBloons)) {
        continue;
      }
         
      action.performAction(this, targetBloons, bloons);
    }
  }
  
  public void lookAt(PVector position) {
    lookAt(position.x, position.y);
  }
  
  public void lookAt(float targetX, float targetY) {
    angle = atan2(targetY - y, targetX - x);
  }
  
  // Only gets the first Bloon in range
  public ArrayList<Bloon> getTargetBloons(ArrayList<Bloon> bloons) {
    ArrayList<Bloon> results = new ArrayList<Bloon>();
    
    Bloon target = targetFilter.getFirst();
    
    if (target != null) {
      results.add(target);
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
}

public class TowerUpgradeManager {
  private static final int MAX_SECONDARY_UPGRADES = 1; // Maximum of 2 upgrades (0 is the first ugprade, 1 is the second)
  private static final int MAX_PATHS_UPGRADED = 2; // Maximum of 2 upgrade paths upgraded
  
  private Tower tower;
  private ArrayList<Integer> pathUpgradeLevelList;
  
  private int mainUpgradePath; // The upgrade path we've put more than 2 upgrades in
  private int pathsUpgraded;
  private int highestUpgradeLevel;
  
  private TowerUpgradeInformation upgradeInformation;
  
  public TowerUpgradeManager(Tower tower) {
    this.tower = tower;
    this.pathUpgradeLevelList = new ArrayList<Integer>();
    
    this.mainUpgradePath = -1;
    this.pathsUpgraded = 0;
    this.highestUpgradeLevel = -1;
    
    this.upgradeInformation = towerPropertyLookup.getTowerProperties(tower.towerName).getUpgradeInformation();
    
    // Set all upgrade levels to -1, which is the base upgrade
    for (int i = 0; i < upgradeInformation.getNumberOfUpgradePaths(); i++) {
      pathUpgradeLevelList.add(-1); 
    }
  }
  
  public int getCurrentLevel(int pathId){
    return pathUpgradeLevelList.get(pathId)+1;
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
    
    int upgradeCost = upgrade.getUpgradeCost();
    
    if (game.getCurrencyManager().getCurrency() < upgradeCost) {
     return false;  
    }
     
    game.getCurrencyManager().removeCurrency(upgradeCost);
    tower.increaseCurrencySpent(upgradeCost);
    
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
    
    // Set range and other basic stuff
    tower.setPropertiesFromUpgrade(upgrade);
    
    // When we buy 2 upgrades on path 1 we want the sprite to stay as the sprite of the 2nd upgrade on path 1
    // So when we buy 1 upgrade on path 2 it doesn't override the sprite
    if (currentUpgradeLevel + 1 > highestUpgradeLevel) {
      tower.setSpriteFromUpgrade(upgrade);
      highestUpgradeLevel = currentUpgradeLevel + 1;
      

    }

    
    JSONObject upgradeChanges = upgrade.getChanges();
    
    // Now update actions
    JSONObject actionChanges = upgradeChanges.getJSONObject("actions");
    if (actionChanges != null) {
      for (String actionName : (Set<String>) actionChanges.keys()) {
        JSONObject currentActionChanges = actionChanges.getJSONObject(actionName);
        TowerAction action = tower.actionMap.get(actionName);
        
        // Create new action! It MUST have a "type" key...
        if (action == null) {
          tower.actionMap.put(actionName, createAction(currentActionChanges.getString("type"), currentActionChanges));
          continue;
        }  
        
        // Update an existing action instead
        

        String actionChangesType = readString(currentActionChanges, "type", action.getActionType());
        
        // Check if the action has changed its type with this upgrade
        // If not, simply update the current action's properties
        if (action.getActionType().equals(actionChangesType)) {
          
          action.setProperties(actionChanges.getJSONObject(actionName));
          
        } else { // Create an entirely new action of the type
        
          // Remove this action
          if (actionChangesType.equals("NULL")) {
            tower.actionMap.remove(actionName);
            continue;
          }
          
          JSONObject newProperties = new JSONObject();
          
          // Inherit any previous action properties (does NOT copy over "type")
          action.reconcileWithOther(newProperties);
          
          // Now, copy over all the properties in changes, including "type"
          newProperties.setString("type", actionChangesType);
          
          // The properties specific to this action type are put in the "properties" table
          newProperties.setJSONObject("properties", currentActionChanges);
          
          TowerAction newAction = createAction(actionChangesType, newProperties);
          tower.actionMap.put(actionName, newAction); // Replace the old action with the new
          
        }

      }
    }

    
    // And then projectiles
    JSONObject projectileChanges = upgradeChanges.getJSONObject("projectiles");
    
    if (projectileChanges != null) {
      for (String projectileName : (Set<String>) projectileChanges.keys()) {
        ProjectileData projectile = tower.projectileMap.get(projectileName);
        // Not directly on the projectiles list, so treat the string as the action name and get the projectile used by that action
        if (projectile == null) {
           String actualProjectileName = ((ProjectileSpawnAction) tower.actionMap.get(projectileName)).getSpawnedProjectileName();
           projectile = tower.projectileMap.get(actualProjectileName);
        }
        
        JSONObject currentChanges = projectileChanges.getJSONObject(projectileName);
        
        String changedType = readString(currentChanges, "type", projectile.type);
        
        // Same type? Update properties
        if (projectile.type.equals(changedType)) {
          projectile.updateProperties(currentChanges);
          return true;
        }
        
        JSONObject newProperties = new JSONObject();
        projectile.reconcileWithOther(newProperties);
        newProperties.setString("type", changedType);
        newProperties.setJSONObject("properties", currentChanges);
        
        ProjectileData newProjectileData = createProjectileData(newProperties);
        
        tower.projectileMap.put(projectileName, newProjectileData);
        
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
  private float cooldownSeconds;
  private String actionType;
  
  public TowerAction(JSONObject actionData) {
    setProperties(actionData);
    this.currentCooldown = this.cooldownTicks;
  }
  
  public void setProperties(JSONObject actionData) {
    if (!actionData.isNull("cooldown")) {
      float readCooldownSeconds = readFloatDiff(actionData, "cooldown", this.cooldownSeconds);
      
      this.cooldownSeconds = readCooldownSeconds;
      
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
  
  public boolean shouldPerformAction(ArrayList<Bloon> targets) {
    return (targets.size() > 0);
  }
  
  public void reconcileWithOther(JSONObject properties) {
    properties.setFloat("cooldown", this.cooldownSeconds);
  }
  
  public void resetCooldown() {
    currentCooldown = 0;
  }
  
  public String getActionType() {
    return actionType;
  }
  
  public void performAction(Tower tower, ArrayList<Bloon> targetBloons, ArrayList<Bloon> bloons) {
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
  
  public void reconcileWithOther(JSONObject properties) {
    super.reconcileWithOther(properties);
    properties.setString("projectile", this.projectileName);
  }
  
  public void performAction(Tower tower, ArrayList<Bloon> targetBloons, ArrayList<Bloon> bloons) {
    resetCooldown();

    ProjectileData data = tower.projectileMap.get(getSpawnedProjectileName());
    
    for (Bloon bloon : targetBloons) {
      tower.projectiles.add(createProjectile(new PVector(tower.x, tower.y), bloon.getPosition().copy(), data));
    }
    
    if (targetBloons.size() > 0) {
      tower.lookAt(targetBloons.get(targetBloons.size() - 1).getPosition());
    }

  }
}
