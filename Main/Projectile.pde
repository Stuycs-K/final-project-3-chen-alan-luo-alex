 public class Projectile{
  float x,y;
  float targetX, targetY;
  int speed;
  int damage;
  boolean finished;
  float dx,dy;
  float distance;
  int imageIndex;
  public ArrayList<PImage> spritesP;
  
  
  public Projectile(float x, float y, float targetX, float targetY, int damage){
    this.x=x;
    this.y=y;
    this.targetX = targetX;
    this.targetY = targetY;
    this.damage = damage;
    this.speed = 5;
    this.finished = false;
    this.dy= targetY - y;
    this.dx= targetX -x;
    this.distance = dist(x,y,targetX,targetY);
    this.imageIndex = imageIndex;
    this.spritesP = new ArrayList<PImage>();
    
  }
  
  public void update(ArrayList<Bloon> bloons){
    if(!finished){
    
      if (distance>0){
        float stepX = (dx/distance) * speed;
        float stepY = (dy/distance) * speed;
        x+= stepX;
        y += stepY;
        
       for(int i = 0; i < bloons.size(); i++){
         Bloon bloon = bloons.get(i);
         float distance = dist(x,y,bloon.getPosition().x, bloon.getPosition().y);
         if(distance<5){
           bloon.damage(damage);
           finished = true;
           break;  
         }
       }
      }
      if(dist(x,y,targetX,targetY) < speed){
        finished = true;
      }
    }
  }
  
  
  
  public void drawProjectile(){
    spritesP.add((loadImage("images/projectiles/basicDart.png")));
    PImage sprite1 = spritesP.get(0);
    if(sprite1 != null){
      pushMatrix();
      translate(x,y);
      float angle = atan2(targetY -y, targetX - x);
      rotate(angle);
      imageMode(CENTER);
      image(sprite1,0,0);
      popMatrix();
    }
   
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
    
    updateProperties(projectileData);
  }
  
  public void updateProperties(JSONObject data) {
    JSONObject specialDamageProperties = data.getJSONObject("specialDamageProperties");
    
    this.popLead = readBoolean(specialDamageProperties, "popLead", this.popLead);
    this.popFrozen = readBoolean(specialDamageProperties, "popFrozen", this.popFrozen);
    this.popBlack = readBoolean(specialDamageProperties, "popBlack", this.popBlack);
    this.extraDamageToCeramics = readInt(specialDamageProperties, "extraDamageToCeramics", this.extraDamageToCeramics);
    this.extraDamageToMoabs = readInt(specialDamageProperties, "extraDamageToMoabs", this.extraDamageToMoabs);
    
    this.damage = readInt(data, "damage", this.damage);
    this.pierce = readInt(data, "pierce", this.pierce);
    this.speed = readInt(data, "speed", this.speed);
    
    if (!data.isNull("sprite")) {
      String spritePath = data.getString("sprite");
      this.sprite = loadImage("images/" + spritePath);
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
