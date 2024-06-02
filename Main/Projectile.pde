Projectile createProjectile(PVector origin, PVector goal, ProjectileData data) {
  Projectile projectile;
  switch (data.type) {
    case "BASE":
      projectile = new Projectile(origin, goal, data);
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
           
           bloon.damage(projectileData.damage);
           
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
 
public class ProjectileData {
  public int damage;
  public int pierce;
  public int speed;
  public PImage sprite;
  
  public boolean popLead;
  public boolean popFrozen;
  public boolean popBlack;
  public int extraDamageToCeramics;
  public int extraDamageToMoabs;
  
  public String type;
  
  public float maxDistance;
  
  public ProjectileData(JSONObject projectileData) {
    // By default, we assume the projectile is sharp (can't pop lead)
    this.popLead = false;
    this.popFrozen = false;
    this.popBlack = true;
    this.extraDamageToCeramics = 0;
    this.extraDamageToMoabs = 0;
    
    this.damage = 1;
    this.pierce = 1;
    this.speed = 30;
    
    this.maxDistance = 30;
    this.type = readString(projectileData, "type", "BASE");
    
    updateProperties(projectileData);
  }
  
  public void updateProperties(JSONObject data) {
    JSONObject specialDamageProperties = data.getJSONObject("specialDamageProperties");
    
    if (specialDamageProperties != null) {
      this.popLead = readBoolean(specialDamageProperties, "popLead", this.popLead);
      this.popFrozen = readBoolean(specialDamageProperties, "popFrozen", this.popFrozen);
      this.popBlack = readBoolean(specialDamageProperties, "popBlack", this.popBlack);
      this.extraDamageToCeramics = readInt(specialDamageProperties, "extraDamageToCeramics", this.extraDamageToCeramics);
      this.extraDamageToMoabs = readInt(specialDamageProperties, "extraDamageToMoabs", this.extraDamageToMoabs);
    }
    
    if (!data.isNull("sprite")) {
      String spritePath = data.getString("sprite");
      this.sprite = loadImage("images/" + spritePath);
    }
    
    this.damage = readIntDiff(data, "damage", this.damage);
    this.pierce = readIntDiff(data, "pierce", this.pierce);
    this.speed = readIntDiff(data, "speed", this.speed);
    this.maxDistance = readFloatDiff(data, "maxDistance", this.maxDistance);
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
