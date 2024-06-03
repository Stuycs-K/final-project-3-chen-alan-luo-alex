public class Bomb extends Projectile{
  public Bomb(PVector origin, PVector goal, ProjectileData data) {
    super(origin, goal, data);
  }
  
  public void update(ArrayList<Bloon> bloons){
    super.update(bloons);
    if (finished){
      explode(bloons);
    }
  }
  
  private void explode(ArrayList<Bloon> bloons){
    BombData bombData = (BombData) projectileData;
    
    for(Bloon bloon : bloons){
      float distance = PVector.dist(new PVector(x, y), new PVector(bloon.getPosition().x, bloon.getPosition().y));
      if(distance <= bombData.explosionRadius) {
        bloon.damage(projectileData.damage);
      }
    }
  }
  //  if(isClusterBombs){
  //    for(int i = 0; i < 8; i++){
  //      float angle = TWO_PI/8;
  //      float clusterTargetX = x * explosionRadius;
  //      float clusterTargetY = y * explosionRadius;
  //      projectiles.add(new BombProjectile(x,y,clusterTargetX,clusterTargetY, projectileData.damage/3, explosionRadius/3, false));
  //    }
  //  }
  //}
  
  //public void drawProjectile(){
  //  //implementing sprites later
  //  pushMatrix();
  //  translate(x,y);
  //  float angle = atan2(targetY-y,targetX-x);
  //  rotate(angle);
  //  popMatrix();
    
  //}
  
    //private float explosionRadius;
  //private boolean isClusterBombs;
  //private ArrayList<Projectile> projectiles;
  
  //public BombProjectile(float x, float y, float targetX, float targetY, int damage, float explosionRadius, boolean isClusterBombs){
  //  super(x,y,targetX,targetY,damage);
  //  this.explosionRadius = explosionRadius;
  //  this.isClusterBombs = isClusterBombs;
  //  //will add sprites for bombs later
  //}
}

public class BombData extends ProjectileData {
  public float explosionRadius;

  public BombData(JSONObject projectileData) {
    super(projectileData);
    this.explosionRadius = projectileData.getFloat("explosionRadius", 150.0f);
  }
           
  public void updateProperties(JSONObject data) {
    super.updateProperties(data);
    this.explosionRadius = readFloatDiff(data, "explosionRadius", this.explosionRadius);
  }
}

public class ClusterBomb extends Bomb {
  public ClusterBomb(PVector origin, PVector goal, ProjectileData data) {
    super(origin, goal, data);
  }
  
  public void update(ArrayList<Bloon> bloons){
    super.update(bloons);
    if (finished){
      explode(bloons);
    }
  }
  
  private void explode(ArrayList<Bloon> bloons){
    super.explode(bloons);
    
    ClusterBombData clusterBombData = (ClusterBombData) projectileData;
    ProjectileData clusterProjectileData = clusterBombData.clusterProjectileData;
    
    PVector origin = new PVector(x, y);
    float anglePerProjectile = TAU / clusterBombData.projectileCount;
    for (int i = 0; i < clusterBombData.projectileCount; i++) {
      PVector projectileDirection = this.direction.copy();
      PVector direction = projectileDirection.rotate(anglePerProjectile * i).normalize();
      
      Projectile clusterProjectileObject = createProjectile(origin, PVector.add(origin, direction), clusterProjectileData);
      
      game.projectiles.add(clusterProjectileObject);
    }
  }
}

public class ClusterBombData extends BombData {
  public int projectileCount;
  public ProjectileData clusterProjectileData;
  
  public ClusterBombData(JSONObject projectileData) {
    super(projectileData);
    
    this.projectileCount = readInt(projectileData, "projectileCount", 4);
  }
  
  public void updateProperties(JSONObject data) {
    super.updateProperties(data);
    
    this.projectileCount = readIntDiff(data, "projectileCount", this.projectileCount);
    
    JSONObject clusterProjectileJSON = data.getJSONObject("clusterProjectileData");
    if (clusterProjectileJSON != null) {
      
      // Create the projectile data if it doesn't exist
      if (this.clusterProjectileData == null) {
        this.clusterProjectileData = createProjectileData(clusterProjectileJSON);
      } else { // Just update the properties
        this.clusterProjectileData.updateProperties(clusterProjectileJSON);
      }

    }

  }
}
