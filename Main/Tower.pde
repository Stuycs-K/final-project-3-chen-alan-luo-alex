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
  public String currentUpgrade;
  public ArrayList<Projectile> projectiles;
  private TowerTargetFilter targetFilter;
  public ArrayList<PImage> sprites;
  public int path;
  public float angle;
  public int hitBoxX;
  public int hitBoxY;
  public int cost;
  
  private PImage sprite;
  
  private HashMap<String, TowerAction> actionMap;
  private HashMap<String, ProjectileData> projectileMap;
  
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
    this.x = x;
    this.y = y;
    
    // Only set the base properties
    TowerPropertyTable properties = towerPropertyLookup.getTowerProperties(towerName);
    JSONObject baseProperties = properties.getBaseProperties();
    
    // First, load the base tower sprite
    this.sprite = loadImage(dataPath("images/" + baseProperties.getString("sprite")));
    
    // Setup actions
    this.actionMap = new HashMap<String, TowerAction>();
    
    JSONObject actionData = baseProperties.getJSONObject("actions");
    for (String actionName : (Set<String>) actionData.keys()) {
      JSONObject actionDefinition = actionData.getJSONObject(actionName);
      
      TowerAction actionObject = new TowerAction(actionDefinition);
      
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
  
  public void attack(ArrayList<Bloon> bloons){
    attackCooldown--;
    if(attackCooldown <=0){
    
      for (Bloon targetBloon: bloons){
        if(targetFilter.canAttack(targetBloon)){
          float distance = dist(x,y,targetBloon.position.x,targetBloon.position.y);
          if(distance<=range){
            angle = atan2(targetBloon.position.y-y, targetBloon.position.x -x);
            projectiles.add(new Projectile(x,y,targetBloon.position.x,targetBloon.position.y,damage));
            attackCooldown = fireRate;
            break;
          }
          }
        }
       
      }
    
  }
  
 public void upgrade(int path){
    this.upgradeLevel++;
    
  }
  
  public void sellTower(Game game){
     game.currency += getSellPrice();
     game.towers.remove(this);
  }
  
  public int getSellPrice(){
    return 0;
  }

  public void draw(){
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

public class TowerAction {
  private int cooldownTicks; // In ticks
  private int currentCooldown;
  private String actionType;
  private String projectileName;
  
  public TowerAction(JSONObject actionData) {
    setProperties(actionData);
    this.currentCooldown = 0;
  }
  
  public void setProperties(JSONObject actionData) {
    float cooldownSeconds = actionData.getFloat("cooldown");
    this.cooldownTicks = int(cooldownSeconds / frameRate);
    
    this.actionType = actionData.getString("type");
    
    this.projectileName = null;
    if (this.actionType.equals("PROJECTILE")) {
      this.projectileName = actionData.getString("projectile"); 
    }
  }
  
  // Called every tick
  public boolean checkCooldown() {
    if (currentCooldown >= cooldownTicks) {
      currentCooldown = 0;
      return true; 
    }
    
    currentCooldown++;
    return false;
  }
  
  public String getActionType() {
    return actionType;
  }
  
  public String getAssociatedProjectileName() {
    return projectileName;
  }
  
  public void performAction(Tower tower, ArrayList<Bloon> bloons) {
    
  }
}
