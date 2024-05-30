public class BombProjectile extends Projectile{
  private float explosionRadius;
  private boolean isClusterBombs;
  
  public BombProjectile(float x, float y, float targetX, float targetY, int damage, float explosionRadius, boolean isClusterBombs){
    super(x,y,targetX,targetY,damage);
    this.explosionRadius = explosionRadius;
    this.isClusterBombs = isClusterBombs;
    //will add sprites for bombs later
  }
  
  public void update(ArrayList<Bloon> bloons){
  }
  
  private void explode(ArrayList<Bloon> bloons){
  }
  
  private void drawProjectile(){
  }
}
