static boolean lineIntersectsCircle(PVector center, float radius, PVector lineStart, PVector lineEnd) {
  float ab2, acab, h2;
  PVector ac = PVector.sub(center, lineStart);
  PVector ab = PVector.sub(lineEnd, lineStart);
  
  ab2 = PVector.dot(ab, ab);
  acab = PVector.dot(ac, ab);
  float t = acab / ab2;
  
  t = constrain(t, 0, 1);
  PVector h = PVector.add(PVector.mult(ab, t), lineStart);
  h.sub(center);
  
  h2 = PVector.dot(h, h);
  
  return h2 <= radius * radius;
}

static boolean circleIntersectsRectangle(PVector center, float radius, PVector rectCenter, float rectRadius) {
  return true; 
}

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
