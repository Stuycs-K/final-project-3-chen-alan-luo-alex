Projectile createProjectile(PVector origin, PVector goal, ProjectileData data) {
  Projectile projectile;
  switch (data.type) {
    case "BASE":
      projectile = new Projectile(origin, goal, data);
      break;
    case "BOMB":
      projectile = new Bomb(origin, goal, (BombData) data);
      break;
    case "CLUSTER_BOMB":
      projectile = new ClusterBomb(origin, goal, (ClusterBombData) data);
      break;
    case "SEEKING":
      projectile  = new SeekingProjectile(origin, goal, data);
      break;
    default:
      projectile = new Projectile(origin, goal, data);
  }
  
  return projectile;
}

ProjectileData createProjectileData(JSONObject definition) {
  ProjectileData projectileData;
  
  String type = readString(definition, "type", "BASE");
  
  switch (type) {
    case "BASE":
      projectileData = new ProjectileData(definition);
      break;
    case "BOMB":
      projectileData = new BombData(definition);
      break;
    case "CLUSTER_BOMB":
      projectileData = new ClusterBombData(definition);
      break;
    case "SEEKING":
      projectileData = new ProjectileData(definition);
    default:
      projectileData = new ProjectileData(definition);
  }
  
  return projectileData;
}

public class Projectile{
  public float x, y;
  public float targetX, targetY;
  public boolean finished;
  public float dx, dy;
  public float distance;
  
  public float distanceTraveled;
  public PVector direction;
  
  public ArrayList<Long> hitBloons;
  public int lifetime;
  
  public ProjectileData projectileData;
  
  public Projectile(PVector origin, PVector goal, ProjectileData data) {
    this.x = origin.x;
    this.y = origin.y;
    this.targetX = goal.x;
    this.targetY = goal.y;
    
    this.dy = targetY - y;
    this.dx = targetX - x;
    this.distance = dist(x, y, targetX, targetY);
    this.finished = false;
    this.distanceTraveled = 0;
    
    this.projectileData = data;
    
    this.direction = new PVector(dx, dy);
    this.lifetime = 0;
    
    this.hitBloons = new ArrayList<Long>(); // For pierce, contains bloon handles
  }
  
  public void setGoalPosition(PVector goal) {
    this.targetX = goal.x;
    this.targetY = goal.y;
    
    this.dy = targetY - y;
    this.dx = targetX - x;
    this.distance = dist(x, y, targetX, targetY);
    
    this.direction = new PVector(dx, dy);
  }
  
  private void applyBlowback(Bloon bloon) {
    if (Math.random() > this.projectileData.blowbackChance) {
      return;
    }
    
    Blowback blowbackEffect = new Blowback();
    bloon.getModifiersList().addModifier(blowbackEffect); 
  }
  
  public void update(ArrayList<Bloon> bloons){
    if (distanceTraveled > projectileData.maxDistance) {
      finished = true;
    }
    
    if (hitBloons.size() >= projectileData.pierce) {
      finished = true;
    }
    
    // Out of bounds
    if (x < 0 || x > width || y < 0 || y > height) {
      finished = true;
    }
    
    lifetime++;
    if(!finished){
    
      if (distance>0){
        float stepX = (dx/distance) * projectileData.speed;
        float stepY = (dy/distance) * projectileData.speed;
        x += stepX;
        y += stepY;
        
        distanceTraveled += Math.sqrt((double) stepX * stepX + (double) stepY * stepY);
        
       for(int i = 0; i < bloons.size(); i++){
         Bloon bloon = bloons.get(i);

         if(bloon.isInBounds(int(x), int(y))){
           // Don't hit the same bloon twice
           if (hitBloons.indexOf(bloon.getHandle()) != -1 || hitBloons.indexOf(bloon.getParentHandle()) != -1) {
             continue;
           }
           
           applyBlowback(bloon);
           float damageDealt = bloon.damage((DamageProperties) projectileData);
           // No damage, so destroy the projectile (we hit a lead bloon with a dart, for example)
           if (damageDealt == -1.0f) {
             finished = true;
             break;
           }
           
           // We tried damaging a dead bloon (in the same frame), so don't count it !
           if (damageDealt != -2.0f) {
             hitBloons.add(bloon.getHandle());
           }

           if (hitBloons.size() >= projectileData.pierce) {
             finished = true;
             break;  
           }
    
         }
       }
      }
      /*
      if(dist(x,y,targetX,targetY) < projectileData.speed){
        finished = true;
      }*/
    }
  }  
  
  public void drawProjectile(){
    //spritesP.add((loadImage("images/projectiles/basicDart.png")));
   
    pushMatrix();
    translate(x, y);
    float angle = atan2(direction.y, direction.x);
    rotate(angle);
    imageMode(CENTER);
    image(projectileData.sprite, 0, 0);
    popMatrix();
  }
}

public class DamageProperties {
  public int damage;
  
  public boolean popLead;
  public boolean popFrozen;
  public boolean popBlack;
  public int extraDamageToCeramics;
  public int extraDamageToMoabs;
  
  public float blowbackChance;
  
  public DamageProperties(JSONObject data) {
    // By default, we assume damage can't pop lead
    // By default, we assume the projectile is sharp (can't pop lead)

    this.popLead = false;
    this.popFrozen = false;
    this.popBlack = true;
    this.extraDamageToCeramics = 0;
    this.extraDamageToMoabs = 0;
    
    this.damage = 1;
    this.blowbackChance = 0;
    
    updateProperties(data);
  }
  
  public void reconcileWithOther(JSONObject properties) {
    JSONObject specialDamageProperties = new JSONObject();
    specialDamageProperties.setBoolean("popLead", this.popLead);
    specialDamageProperties.setBoolean("popFrozen", this.popFrozen);
    specialDamageProperties.setBoolean("popBlack", this.popBlack);
    specialDamageProperties.setInt("extraDamageToCeramics", this.extraDamageToCeramics);
    specialDamageProperties.setInt("extraDamageToMoabs", this.extraDamageToMoabs);
    
    properties.setJSONObject("specialDamageProperties", specialDamageProperties);
    
    properties.setInt("damage", this.damage);
    properties.setFloat("blowbackChance", this.blowbackChance);
  }
  
  public void updateProperties(JSONObject data) {
    JSONObject specialDamageProperties = data.getJSONObject("specialDamageProperties");
    
    JSONObject target = specialDamageProperties;
    if (target == null) {
      target = data;
    }
    
    // These are either in a subtable ("specialDamageProperties") or direct children of data
    this.popLead = readBoolean(target, "popLead", this.popLead);
    this.popFrozen = readBoolean(target, "popFrozen", this.popFrozen);
    this.popBlack = readBoolean(target, "popBlack", this.popBlack);
    this.extraDamageToCeramics = readIntDiff(target, "extraDamageToCeramics", this.extraDamageToCeramics);
    this.extraDamageToMoabs = readIntDiff(target, "extraDamageToMoabs", this.extraDamageToMoabs);
    
    this.damage = readIntDiff(data, "damage", this.damage);
    this.blowbackChance = readFloatDiff(data, "blowbackChance", this.blowbackChance);
    
    JSONObject otherProperties = data.getJSONObject("properties");
    if (otherProperties != null) {
      updateProperties(otherProperties);
    }
  }
}
 
public class ProjectileData extends DamageProperties {
  public int pierce;
  public int speed;
  public PImage sprite;
  public String spritePath;
  
  public String type;
  
  public float maxDistance;

  
  public ProjectileData(JSONObject projectileData) {
     super(projectileData);
     this.type = readString(projectileData, "type", "BASE");
  }
  
  public void reconcileWithOther(JSONObject properties) {
    super.reconcileWithOther(properties);
    
    properties.setString("sprite", this.spritePath);
    properties.setInt("pierce", this.pierce);
    properties.setInt("speed", this.speed);
    properties.setFloat("maxDistance", this.maxDistance);
  }
  
  public void updateProperties(JSONObject data) {
    super.updateProperties(data);
    
    if (!data.isNull("sprite")) {
      String spritePath = data.getString("sprite");
      this.sprite = loadImage("images/" + spritePath);
      this.spritePath = spritePath;
    }
    
    this.pierce = readIntDiff(data, "pierce", this.pierce);
    this.speed = readIntDiff(data, "speed", this.speed);
    this.maxDistance = readFloatDiff(data, "maxDistance", this.maxDistance);
    
    JSONObject otherProperties = data.getJSONObject("properties");
    if (otherProperties != null) {
      updateProperties(otherProperties);
    }
  }
  
}




  
//public class ProjectileImages{
//  private ArrayList<PImage> images;
  
//  public ProjectileImages() {
//        this.images = new ArrayList<>();
//        addImagesDartMonkey(); 
//    }
  
//  public void addImagesDartMonkey(){
//    images.add((loadImage("images/projectiles/basicDart.png")));
    
//  }
  
//  public PImage getImage(int index){
//    return images.get(index);
//  }
//}
