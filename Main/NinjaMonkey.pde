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
      // Don't home in on the same enemy
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
    super.update(bloons);
    
    if (lifetime > 10) {
      Bloon target = getTargetBloon();
      if (target != null) {
        setGoalPosition(target.position);
      }
    }
  }  
}
