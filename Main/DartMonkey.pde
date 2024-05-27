public class DartMonkey extends Tower{
  
  public DartMonkey (int x, int y){
    super(x,y,150,20,5,10);
  }
  
  public void attack(ArrayList<Bloon> bloon){
    super.attack(bloon);
    }
  
  
  public void upgrade(int path){
    if(upgradeLevel == 1){
      if(path==1){
        radius+=25;
      }else if(path ==2){
        damage += 1; //not sure how to implement sharpshots yet
      }
    } else if (upgradeLevel == 2){
      if(path==1){
        radius+=25;
        targetFilter.a
  
  
  
  public void draw(){
    //println("Drawing DartMonkey at: " + x + ", " + y);
    
    ellipse(x,y,20,20);
    for(Projectile projectile : projectiles){
      projectile.drawProjectile();
    }
  }
  
  public int getCost(){
    return 0;
  }
}
