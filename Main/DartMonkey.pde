public class DartMonkey extends Tower{
  
  public DartMonkey (int x, int y){
    super("DartMonkey", x, y);
    /*
    super(x,y,200,20,1,10,20,50);
    this.sprites = new ArrayList<PImage>();
    sprites.add(loadImage("images/towers/dartmonkey.png"));
    sprites.add(loadImage("images/towers/LongRangeDarts.png"));
    //sprites.add(loadImage("images/towers/
    this.path = 0;
    */
  }
  
  /*
  public void attack(ArrayList<Bloon> bloon){
    super.attack(bloon);
    } */

  public void upgrade(int path){
    upgradeLevel++;
    if(upgradeLevel == 1){
      if(path==1){
        range+=25;
      }else if(path ==2){
        damage += 1;
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
    
  }
  
  
  /*
  public void draw(){
    pushMatrix();
    translate(x,y);
    rotate(angle+HALF_PI);
    if (upgradeLevel == 0){
      PImage spriteZero = sprites.get(0);
      if (spriteZero != null) {
        imageMode(CENTER);
        image(spriteZero, 0, 0);
    }
   }
    if(upgradeLevel == 1){
      PImage spriteOne = sprites.get(1);
      if(spriteOne != null){
          imageMode(CENTER);
          image(spriteOne, 0, 0);
        }
      if(path == 1){
    
       }
      if(path == 2){
        //implementing projectile changes later
      }
    }
    if(upgradeLevel == 2){
      PImage spriteTwo = sprites.get(2);
      if(spriteTwo != null){
          imageMode(CENTER);
          image(spriteTwo, 0, 0);
        }
      if(path == 1){

       }
      if(path == 2){
        //implementing projectile changes later
      }
     if(upgradeLevel ==3){
       if(path==1){
       }
       if(path == 2){
         
       }
       
     }
    }
  
        
        
  popMatrix();
    for(Projectile projectile : projectiles){
      projectile.drawProjectile();
    }
  }*/
  
  public int getCost(){
    return 200;
  }
}
