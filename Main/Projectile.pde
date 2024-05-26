public class Projectile{
  int x,y;
  int targetX, targetY;
  int speed;
  int damage;
  boolean finished;
  int dx,dy;
  int distance;
  
  public Projectile(int x, int y, int targetX, int targetY, int damage){
    this.x=x;
    this.y=y;
    this.targetX = targetX;
    this.targetY = targetY;
    this.damage = damage;
    this.speed = 5;
    this.finished = false;
    dy= targetY - y;
    dx= targetX -x;
    distance = dist(x,y,targetX,targetY);
  }
  
  public void update(){
    
  }
  
  
  public void draw(){
  }
  
}
