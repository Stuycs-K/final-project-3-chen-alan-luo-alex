public class Projectile{
  int x,y;
  int targetX, targetY;
  int speed;
  int damage;
  boolean finished;
  int dx,dy;
  float distance;
  
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
    if (distance>0){
      float stepX = (dx/distance) * speed;
      float stepY = (dy/distance) * speed;
      x+= stepX;
      y += stepY;
      if(dist(x,y,targetX,targetY) < speed){
        finished = true;
      }
    }
  }
  
  
  public void draw(){
    fill(255,0,0);
    ellipse(x,y,5,5);
  }
  
}
