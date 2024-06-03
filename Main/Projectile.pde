Projectile createProjectile(PVector origin, PVector goal, ProjectileData data) {
  Projectile projectile;
  switch (data.type) {
    case "BASE":
      projectile = new Projectile(origin, goal, data);
      break;
    case "BOMB":
      projectile = new BombProjectile(origin, goal, (BombData)data);
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
  
  private float distanceTraveled;
  private PVector direction;
  
  private ArrayList<Long> hitBloons;
  
  public Projectile(float x, float y, float targetX, float targetY, int damage){
    this.x=x;
    this.y=y;
    this.targetX = targetX;
    this.targetY = targetY;
    this.finished = false;
    this.dy= targetY - y;
    this.dx= targetX -x;
    this.distance = dist(x,y,targetX,targetY);
  }
  
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
    
    this.hitBloons = new ArrayList<Long>(); // For pierce, contains bloon handles
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
           
           boolean didDamage = bloon.damage((DamageProperties) projectileData);
           // No damage, so destroy the projectile (we hit a lead bloon with a dart, for example)
           if (!didDamage) {
             finished = true;
             break;
           }
           
           hitBloons.add(bloon.getHandle());
           
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
  
  public DamageProperties(JSONObject data) {
    // By default, we assume damage can't pop lead
    // By default, we assume the projectile is sharp (can't pop lead)

    this.popLead = false;
    this.popFrozen = false;
    this.popBlack = true;
    this.extraDamageToCeramics = 0;
    this.extraDamageToMoabs = 0;
    
    this.damage = 1;

    updateProperties(data);
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
  }
}
 
public class ProjectileData extends DamageProperties {
  public int pierce;
  public int speed;
  public PImage sprite;
  
  public String type;
  
  public float maxDistance;

  
  public ProjectileData(JSONObject projectileData) {
     super(projectileData);
     this.type = readString(projectileData, "type", "BASE");
  }
  
  public void updateProperties(JSONObject data) {
    super.updateProperties(data);

    if (!data.isNull("sprite")) {
      String spritePath = data.getString("sprite");
      this.sprite = loadImage("images/" + spritePath);
    }
    
    this.pierce = readIntDiff(data, "pierce", this.pierce);
    this.speed = readIntDiff(data, "speed", this.speed);
    this.maxDistance = readFloatDiff(data, "maxDistance", this.maxDistance);
  }
  
}

public class BombData extends ProjectileData {
  public float explosionRadius;

  public BombData(JSONObject projectileData) {
    super(projectileData);
    this.explosionRadius = projectileData.getFloat("explosionRadius", 50.0f); // default explosion radius
  }
           
  public void updateProperties(JSONObject data) {
    super.updateProperties(data);
    this.explosionRadius = readFloatDiff(data, "explosionRadius", this.explosionRadius);
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
