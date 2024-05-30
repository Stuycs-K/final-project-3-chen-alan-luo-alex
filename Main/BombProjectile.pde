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
    if(!finished){
      if(distance > 0){
        float stepX = (dx / distance) * speed;
        float stepY = (dy / distance) * speed;
        x += stepX;
        y += stepY;
        
        if(dist(x,y,targetX,targetY) < speed){
          explode(bloons);
          finished = true;
        }
      }
    }
  }
  
  private void explode(ArrayList<Bloon> bloons){
    for(Bloon bloon : bloons){
      float distanceToBloon = dist(x,y,bloon.getPosition().x, bloon.getPosition().y);
      if(distanceToBloon<=explosionRadius){
        bloon.damage(damage);
      }
    }
  }
  
  private void drawProjectile(){
    //implementing sprites later
    pushMatrix();
    translate(x,y);
    float angle = atan2(targetY-y,targetX-x);
    rotate(angle);
    popMatrix();
    
  }
}
}
}
