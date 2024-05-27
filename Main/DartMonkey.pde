public class DartMonkey extends Tower{
  
  public DartMonkey (int x, int y){
    super(x,y,150,20,5,10);
  }
  
  public void attack(ArrayList<Bloon> bloon){
    super.attack(bloon);
    }
  
  
  public void upgrade(int path){
    if (path == 1){
      String[] upgradesPathOne = new String []{"Default","Long Range Darts", "Enchanced Eyesight","Spike-O-Pult","Juggernaut"};
    }
    if(path == 2){
      String[] upgradePathTwo = new String[]{"Sharp Shots","Razor Sharp Shots","Triple Darts","Super Monkey Fan Club"};
    }
  }
  
  
  
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
