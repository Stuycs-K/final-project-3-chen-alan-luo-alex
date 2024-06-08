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

static boolean pointInCircle(PVector center, float radius, PVector point) {
  float dx = point.x - center.x;
  float dy = point.y - center.y;
  
  return dx * dx + dy * dy <= radius * radius;
}

static boolean circleIntersectsCircle(PVector center1, float radius1, PVector center2, float radius2) {
  float radiiSum = radius1 + radius2;
  float radiiDifference = radius1 - radius2;
  
  float dx = center1.x - center2.x;
  float dy = center1.y - center2.y;
  
  return radiiDifference * radiiDifference <= dx * dx + dy * dy && dx * dx + dy * dy <= radiiSum * radiiSum; 
}

static boolean pointInRectangle(PVector point, PVector[] vertices) {
  float ab2, ad2, apab, apad;
  
  PVector a = vertices[0];
  PVector b = vertices[1];
  PVector d = vertices[3];
  
  PVector ab = PVector.sub(b, a);
  PVector ad = PVector.sub(d, a);
  PVector ap = PVector.sub(point, a);
  
  ab2 = PVector.dot(ab, ab);
  ad2 = PVector.dot(ad, ad);
  apab = PVector.dot(ap, ab);
  apad = PVector.dot(ap, ad);
  
  return apab >= 0 && apab <= ab2 && apad >= 0 && apad <= ad2;
}

static boolean circleIntersectsRectangle(PVector center, float radius, PVector[] vertices) {
  return (pointInRectangle(center, vertices) 
    || lineIntersectsCircle(center, radius, vertices[0], vertices[1])
    || lineIntersectsCircle(center, radius, vertices[1], vertices[2])
    || lineIntersectsCircle(center, radius, vertices[2], vertices[3])
    || lineIntersectsCircle(center, radius, vertices[3], vertices[0]));
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
    
    int bloonsHitByExplosion = 0;
    
    for(Bloon bloon : bloons){
      if (bloonsHitByExplosion >= bombData.explosionPierce) {
        return;
      }
      
      if (circleIntersectsRectangle(new PVector(x, y), bombData.explosionRadius, bloon.getHitboxVertices())) {
        if (bombData.stunDuration > 0) {
          Stun stunModifier = new Stun();
          stunModifier.setDuration(bombData.stunDuration);
          bloon.getModifiersList().addModifier(stunModifier); 
        }
        
        bloon.damage((DamageProperties) bombData);
        bloonsHitByExplosion++;
      }
    }
  }
}

public class BombData extends ProjectileData {
  public float explosionRadius;
  public int explosionPierce;
  public float stunDuration;

  public BombData(JSONObject projectileData) {
    super(projectileData);
    
    JSONObject target = projectileData.getJSONObject("properties");
    if (target == null) {
      target = projectileData;
    }
    
    this.explosionRadius = target.getFloat("explosionRadius", 150.0f);
    this.explosionPierce = target.getInt("explosionPierce", 10);
    this.stunDuration = target.getFloat("stunDuration", 0);
  }
  
  public void reconcileWithOther(JSONObject properties) {
    super.reconcileWithOther(properties);
    
    properties.setFloat("explosionRadius", this.explosionRadius);
    properties.setInt("explosionPierce", this.explosionPierce);
    properties.setFloat("stunDuration", this.stunDuration);
  }
           
  public void updateProperties(JSONObject data) {
    super.updateProperties(data);
    
    JSONObject target = data.getJSONObject("properties");
    if (target == null) {
      target = data;
    }
    
    this.explosionRadius = readFloatDiff(target, "explosionRadius", this.explosionRadius);
    this.explosionPierce = readIntDiff(target, "explosionPierce", this.explosionPierce);
    this.stunDuration = readFloatDiff(target, "stunDuration", this.stunDuration);
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
    
    JSONObject target = projectileData.getJSONObject("properties");
    if (target == null) {
      target = projectileData;
    }
    
    this.projectileCount = readInt(target, "projectileCount", 4);
  }
  
  public void reconcileWithOther(JSONObject properties) {
    super.reconcileWithOther(properties);
    
    properties.setInt("projectileCount", this.projectileCount);
    
    JSONObject clusterData = new JSONObject();
    clusterProjectileData.reconcileWithOther(clusterData);
    properties.setJSONObject("clusterProjectileData", clusterData);
  }
  
  public void updateProperties(JSONObject data) {
    super.updateProperties(data);
    
    JSONObject target = data.getJSONObject("properties");
    if (target == null) {
      target = data;
    }
    
    this.projectileCount = readIntDiff(target, "projectileCount", this.projectileCount);
    
    JSONObject clusterProjectileJSON = target.getJSONObject("clusterProjectileData");
    if (clusterProjectileJSON != null) {
      
      // Create the projectile data if it doesn't exist
      if (this.clusterProjectileData == null) {
        this.clusterProjectileData = createProjectileData(clusterProjectileJSON);
      } else { // Just update the properties
      
        if (!clusterProjectileJSON.isNull("type") && !clusterProjectileJSON.getString("type").equals(clusterProjectileData.type)) {   
          JSONObject newProperties = new JSONObject();
          this.clusterProjectileData.reconcileWithOther(newProperties);
          newProperties.setString("type", clusterProjectileJSON.getString("type"));
          newProperties.setJSONObject("properties", clusterProjectileJSON);
          
          this.clusterProjectileData = createProjectileData(newProperties);

        } else {
          this.clusterProjectileData.updateProperties(clusterProjectileJSON);
        }
      }

    }

  }
}
