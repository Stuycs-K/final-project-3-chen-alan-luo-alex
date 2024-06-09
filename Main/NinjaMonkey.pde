public class NinjaMonkey extends Tower {
  public NinjaMonkey(int x, int y) {
    super("NinjaMonkey", x, y);
  }
}

public class SeekingProjectile extends Projectile {
  public SeekingProjectile(PVector origin, PVector goal, ProjectileData data) {
    super(origin, goal, data);
  }
  
  private Bloon getTargetBloon() {
    Bloon closest = null;
    float closestDistance = Float.MAX_VALUE;
    for (Bloon bloon : game.bloons) {
      if (hitBloons.indexOf(bloon.getHandle()) != -1 || hitBloons.indexOf(bloon.getParentHandle()) != -1) {
        continue;
      }
      float distance = dist(x, y, bloon.position.x, bloon.position.y);
      if (distance < closestDistance) {
        closest = bloon;
        closestDistance = distance;
      }
    }
    
    return closest;
  }
  
  public void update(ArrayList<Bloon> bloons){
    if (distanceTraveled > projectileData.maxDistance) {
      finished = true;
    }
    
    if (hitBloons.size() >= projectileData.pierce) {
      finished = true;
    }
    
    // Out of bounds
    if (x < 0 || x > width || y < 0 || y > height) {
      finished = true;
    }
    
    Bloon target = getTargetBloon();
    if (target != null) {
      setGoalPosition(target.position);
    }
    
    if (!finished) {
    
      if (distance>0){
        float stepX = (dx/distance) * projectileData.speed;
        float stepY = (dy/distance) * projectileData.speed;
        x += stepX;
        y += stepY;
        
        distanceTraveled += Math.sqrt((double) stepX * stepX + (double) stepY * stepY);
        
        
        for (int i = 0; i < bloons.size(); i++) {
          Bloon bloon = bloons.get(i);

          if(bloon.isInBounds(int(x), int(y))){
            // Don't hit the same bloon twice
            if (hitBloons.indexOf(bloon.getHandle()) != -1 || hitBloons.indexOf(bloon.getParentHandle()) != -1) {
              continue;
            }
           
            boolean didDamage = bloon.damage((DamageProperties) projectileData);
            // No damage, so destroy the projectile (we hit a lead bloon with a dart, for example)
            if (!didDamage) {
              finished = true;
              break;
            }
           
            hitBloons.add(bloon.getHandle());
           
            if (hitBloons.size() >= projectileData.pierce) {
              finished = true;
              break;  
            }
    
         }
       }
      }
    }
  }  
}
