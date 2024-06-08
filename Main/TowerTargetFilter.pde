public class TowerTargetFilter{
  private boolean canDetectCamo;
  private Tower tower;
  
  public TowerTargetFilter(Tower tower){
    this.tower = tower;
    this.canDetectCamo = false;
  }
  
  public void setCamoDetection(boolean canDetectCamo){
    this.canDetectCamo = canDetectCamo;
  }
  
  public boolean canDetectCamo() {
    return this.canDetectCamo;
  }
  
  public boolean canAttack(Bloon bloon){
    BloonModifiersList modifiersList = bloon.getModifiersList();
    if(modifiersList.hasModifier("camo") && !this.canDetectCamo){
      return false;
    }
    
    return true;
  }
  
  // Not great, but it'll do...
  public Bloon getFirst() {
    return getFirst(new ArrayList<Bloon>()); 
  }
  
  public Bloon getFirst(ArrayList<Bloon> blacklist) {
    float maxDistance = -1;
    Bloon firstBloon = null;
    
    for (Bloon bloon : game.bloons) {
      if (blacklist.indexOf(bloon) != -1) {
        continue;
      }
      
      if (!canAttack(bloon)) {
        continue;
      }
      
      if (dist(tower.x, tower.y, bloon.position.x, bloon.position.y) > tower.range) {
        continue;
      }
      
      float distanceTraveled = bloon.getDistanceTraveled();
      
      if (distanceTraveled > maxDistance) {
        maxDistance = distanceTraveled;
        firstBloon = bloon;
      }
    }
    
    return firstBloon;
  }
  
  public Bloon getLast() {
    return getLast(new ArrayList<Bloon>()); 
  }
  
  public Bloon getLast(ArrayList<Bloon> blacklist) {
    float minDistance = Float.MAX_VALUE;
    Bloon lastBloon = null;
    
    for (Bloon bloon : game.bloons) {
      if (blacklist.indexOf(bloon) != -1) {
        continue;
      }
      
      if (!canAttack(bloon)) {
        continue;
      }
      
      if (dist(tower.x, tower.y, bloon.position.x, bloon.position.y) > tower.range) {
        continue;
      }
      
      float distanceTraveled = bloon.getDistanceTraveled();
      
      if (distanceTraveled < minDistance) {
        minDistance = distanceTraveled;
        lastBloon = bloon;
      }
    }
    
    return lastBloon;
  }
  
  public Bloon getClosest() {
    return getLast(new ArrayList<Bloon>()); 
  }
  
  public Bloon getClosest(ArrayList<Bloon> blacklist) {
    float minDistance = Float.MAX_VALUE;
    Bloon closestBloon = null;
    
    for (Bloon bloon : game.bloons) {
      if (blacklist.indexOf(bloon) != -1) {
        continue;
      }
      
      if (!canAttack(bloon)) {
        continue;
      }
      
      float distance = dist(tower.x, tower.y, bloon.position.x, bloon.position.y);
      if (distance > tower.range) {
        continue;
      }
      
      if (distance < minDistance) {
        minDistance = distance;
        closestBloon = bloon;
      }
    }
    
    return closestBloon;
  }
  
}
