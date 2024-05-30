public class BombShooter extends Tower{
  private int bombRange;
  private int bombDamage;
  private float explosionRadius;
  private boolean isClusterBombs;
  private boolean isMissle;
  private TowerTargetFilter targetFilterBomb;
  
  public BombShooter(int x, int y){
    
    super(x,y);
    this.bombRange = 100;
    this.bombDamage = 1;
    this.explosionRadius = 50;
    this.cost = 100;
    this.upgradePath = 0;
    this.upgradeLevel = 0;
    this.isClusterBombs = false;
    this.isMissle = false;
    this.targetFilterBomb = new TowerTargetFilter();
    //sprites.add(loadImage("images/Towers/moabTower.png"));
    
  }
  
  public void attack(ArrayList<Bloon> bloons){
    for (Bloon targetBloon: bloons) {
      if(targetFilterBomb.canAttack(targetBloon)){
        if (dist(x,y,targetBloon.position.x,targetBloon.position.y) <= bombRange) {
          projectiles.add(new BombProjectile(x,y,targetBloon.position.x,targetBloon.position.y,bombDamage,explosionRadius,isClusterBombs));
          break;
        }
      }
    }
  }
  
  public void upgrade(int path){
    upgradeLevel++;
    if(upgradeLevel == 1){
      if(path==1){
        bombRange+=50;
      }else if(path ==2){
        explosionRadius+=25;
      }
    } else if (upgradeLevel == 2){
      if(path==1){
        // soon to be implemented frag bombs
      }else if(path == 2){
        bombRange += 25;
        attackSpeed += 10; 
        isMissle = true;
      }
    } else if(upgradeLevel == 3){
      if(path ==1){
        //clusters implemented soon
        isClusterBombs = true;
      } else if (path == 2){
        bombDamage = 3;
      }
    }

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
