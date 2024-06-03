public class BombProjectile extends Projectile{
  
  public BombProjectile(PVector origin, PVector goal, ProjectileData data) {
    super(origin, goal, data);
    }
  
  public void update(ArrayList<Bloon> bloons){
    super.update(bloons);
    if (finished){
      explode(bloons);
    }
  }
  
  private void explode(ArrayList<Bloon> bloons){
    for(Bloon bloon : bloons){
      float distance = PVector.dist(new PVector(x, y), new PVector(bloon.x, bloon.y));
      if(distance <= ((BombData)projectileData).explosionRadius){
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
