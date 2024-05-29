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
    
    //PImage projectileImage = projectileImages.getImage(imageIndex);
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
