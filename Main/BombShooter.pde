public class BombShooter extends Tower{
  public BombShooter(int x, int y){
    super(x,y,50,30,10,5,20);
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
        radius+=25;
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
    fill(0,0,255);
    ellipse(x,y,25,25);
  }
  
  public int getCost(){
    return 0;
  }
}
