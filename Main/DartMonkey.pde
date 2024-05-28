public class DartMonkey extends Tower{
  
  public DartMonkey (int x, int y){
    super(x,y,200,20,1,10,20);
    this.sprites = new ArrayList<PImage>();
    sprites.add(loadImage("images/Towers/dartmonkey.png"));
    //this.sprite = loadImage("images/Towers/dartmonkey.png");
  }
  
  public void attack(ArrayList<Bloon> bloon){
    super.attack(bloon);
    }
  
  
  public void upgrade(int path){
    if(upgradeLevel == 1){
      if(path==1){
        range+=25;
      }else if(path ==2){
        damage += 1; //not sure how to implement sharpshots yet
      }
    } else if (upgradeLevel == 2){
      if(path==1){
        range+=25;
        TowerTargetFilter targetFilter = new TowerTargetFilter();
        targetFilter.setCamoDetection(true);
      }else if(path == 2){
        damage += 1;
      }
    } else if(upgradeLevel == 3){
      if(path ==1){
        fireRate = 154;
        damage = 18;
      } else if (path == 2){
        damage = 3;
      }
    }
    upgradeLevel++;
  }
  
  
  
  public void draw(){
    //println("Drawing DartMonkey at: " + x + ", " + y);
    PImage sprite = sprites.get(0);
    if (sprite != null) {
      imageMode(CENTER);
      image(sprite, x, y);
    
    }
    for(Projectile projectile : projectiles){
      projectile.drawProjectile();
    }
  }
  
  public int getCost(){
    return 0;
  }
}
