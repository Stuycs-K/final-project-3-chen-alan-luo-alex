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

  /*
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

// This is for the Triple Darts upgrade
public class MultiProjectileSpawnAction extends ProjectileSpawnAction {
  private int projectileCount;
  private float angle;
  
  public MultiProjectileSpawnAction(JSONObject actionData) {
    super(actionData);
  }
  
  public void setProperties(JSONObject actionData) {
    super.setProperties(actionData);
    
    this.projectileCount = readIntDiff(actionData, "projectileCount", this.projectileCount);
    this.angle = readFloatDiff(actionData, "angle", this.angle);
    
    JSONObject otherProperties = actionData.getJSONObject("properties");
    if (otherProperties != null) {
      setProperties(otherProperties);
    }
  }
  
  public void reconcileWithOther(JSONObject properties) {
    super.reconcileWithOther(properties);
    properties.setInt("projectileCount", this.projectileCount);
    properties.setFloat("angle", this.angle);
  }
  
  public void performAction(Tower tower, ArrayList<Bloon> targetBloons, ArrayList<Bloon> bloons) {
    resetCooldown();

    PVector towerPosition = new PVector(tower.x, tower.y);
    ProjectileData data = tower.projectileMap.get(getSpawnedProjectileName());
    
    for (Bloon bloon : targetBloons) {
      PVector position = bloon.getPosition();
      
      // Pattern: 0, -0, angle, -angle, angle * 2, -angle * 2
      for (int i = 0; i < projectileCount; i++) {
        float angle = 0;
        
        if (i != 0) {
          angle = this.angle * (int) (Math.ceil((double) i / 2));
        
          if (i % 2 == 0) {
            angle *= -1;
          }
        }
        
        PVector goalPosition = new PVector(position.x, position.y);

        PVector direction = goalPosition.sub(towerPosition).rotate(angle);
        
        tower.projectiles.add(createProjectile(towerPosition, PVector.add(towerPosition, direction), data));
      }
      
    }
    
    if (targetBloons.size() > 0) {
      tower.lookAt(targetBloons.get(targetBloons.size() - 1).getPosition());
    }

  }
}
