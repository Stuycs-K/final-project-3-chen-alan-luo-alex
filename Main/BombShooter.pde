public class BombShooter extends Tower{
  public BombShooter(int x, int y){
    super(x,y,50,30,10,5,20);
    sprites.add(loadImage("images/Towers/moabTower.png"));
    //this.sprite = loadImage("images/Towers/moabTower.png");
  }
  
  public void attack(ArrayList<Bloon> bloon){
    super.attack(bloon);
  }
  
  public void upgrade(int path){
    if(upgradeLevel == 1){
      if(path==1){
        range+=25;
      }else if(path ==2){
        radius+=25;
      }
    } else if (upgradeLevel == 2){
      if(path==1){
        // soon to be implemented frag bombs
      }else if(path == 2){
        range += 25;
        attackSpeed += 10;
      }
    } else if(upgradeLevel == 3){
      if(path ==1){
        //clusters implemented soon
      } else if (path == 2){
        damage = 3;
      }
    }
    upgradeLevel++;
  }

  
  public void draw(){
    fill(0,0,255);
    ellipse(x,y,25,25);
    
    
    //if (upgradeLevel == 3){
    //  if(//implemented soon so that player can  invoke this ifpath==2)){
    //    if (sprite != null) {
    //      imageMode(CENTER);
    //      image(sprite, x, y);
    
    //}
  // }
  //}
 }
  
  public int getCost(){
    return 0;
  }
}
