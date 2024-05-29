 public class Projectile{
  float x,y;
  float targetX, targetY;
  int speed;
  int damage;
  boolean finished;
  float dx,dy;
  float distance;
  
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
    pushStyle();
    fill(0,255,0);
    ellipse(x,y,5,5);
    popStyle();
  }
  
}

public class ProjectileImages{
  private static ArrayList<PImage> images = new ArrayList<>();
  
  public void addImagesDartMonkey(){
    images.add((loadImage("images/projectiles/dartmonkey.png"));
    
  }
  
  public PImage getImage(int index){
    return images.get(index);
  }
}
