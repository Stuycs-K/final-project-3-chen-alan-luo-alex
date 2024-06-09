public class BloonSpawner {
  public static final int CHILDREN_SPAWN_SPACING = 25;
  
  ArrayList<Bloon> createdBloonQueue;
  
  public BloonSpawner() {
    createdBloonQueue = new ArrayList<Bloon>();
  }
  
  public ArrayList<Bloon> spawnChildren(JSONObject childrenSpawnInformation, Bloon parent) {
    ArrayList<Bloon> createdBloons = new ArrayList<Bloon>();
    
    String layerName = childrenSpawnInformation.getString("layerName");
    int numberOfChildren = childrenSpawnInformation.getInt("count");
    String spawnSpacingString = childrenSpawnInformation.getString("spacing");
    
    int spawnSpacing = CHILDREN_SPAWN_SPACING;
    if (spawnSpacingString != null) {
      spawnSpacing = Integer.parseInt(spawnSpacingString); 
    }
    
    // Get segments
    PVector startPosition = parent.getPosition();
    int currentMapSegmentId = parent.getPositionId();

    for (int j = 0; j < numberOfChildren; j++) {
      
      if (parent.getModifiersList().hasModifier("blowback")) {
        Bloon newBloon = new Bloon(layerName, startPosition);
        newBloon.positionId = parent.positionId;
        
        createdBloonQueue.add(newBloon);
        
        createdBloons.add(newBloon);
        continue;
      }
      
      float distanceOffset = -1 * spawnSpacing * j; // The first child will spawn in the exact same position; subsequent bloons will spawn behind
      
      int currentSegmentId = currentMapSegmentId; 
      PVector finalSpawnPosition = startPosition;
      
      while (true) {
        // Invalid segment id, so spawn where we currently are
        if (currentSegmentId < 0) {
          finalSpawnPosition = startPosition;
          break;
        }
        MapSegment currentSegment = game.getMap().getMapSegment(currentSegmentId);
        if (currentSegment == null) {
          finalSpawnPosition = startPosition;
          break;
        }
        
        // Direction to move from the original spawn position
        PVector direction = PVector.sub(currentSegment.getEnd(), currentSegment.getStart()).normalize();
        direction.mult(distanceOffset);
        
        // Try to move by distance; if we're outside the current map segment, move the child bloon to the previous map segment
        PVector resultSpawnPosition = PVector.add(finalSpawnPosition, direction);
        
        // This would spawn the bloon too far back, so try again with the previous segment
        if (!currentSegment.isBetweenStartAndEnd(resultSpawnPosition)) {
          float distanceToStart = PVector.dist(finalSpawnPosition, currentSegment.getStart());
          
          if (distanceOffset < 0) {
            distanceOffset += distanceToStart;
          } else {
            distanceOffset -= distanceToStart;
          }
          
          finalSpawnPosition = currentSegment.getStart();
          
          // Go to the previous map segment
          if (distanceOffset < 0) {
            currentSegmentId -= 1;
          } else {
            currentSegmentId += 1;
          }
          
        } else {
          finalSpawnPosition = resultSpawnPosition;
          break;
        } 
      }
      
      Bloon newBloon = new Bloon(layerName, finalSpawnPosition);
      createdBloonQueue.add(newBloon);
      
      createdBloons.add(newBloon);
    }
    
    ArrayList<BloonModifier> heritableModifiers = parent.getModifiersList().getHeritableModifiers();
    for (Bloon newBloon : createdBloons) {
      newBloon.getModifiersList().copyModifiers(heritableModifiers);
      
      // Set parent handle so certain attacks don't hit them too many times
      long parentHandle = parent.getParentHandle();
      if (parentHandle == -1) {
        parentHandle = parent.getHandle();
      }
      newBloon.setParentHandle(parentHandle);
      
      // Set distance traveled
      newBloon.setDistanceTraveled(parent.getDistanceTraveled());
    }

    return createdBloons;
  }
  
  private void setModifiers(JSONObject spawnInformation, Bloon bloon) {
    if (spawnInformation.isNull("modifiers")) {
      return;
    }
    
    JSONObject modifiers = spawnInformation.getJSONObject("modifiers");
    bloon.getModifiersList().addModifiers(modifiers);
  }
  
  public ArrayList<Bloon> spawn(JSONObject spawnInformation, PVector position) {
    ArrayList<Bloon> createdBloons = new ArrayList<Bloon>();
    
    String layerName = spawnInformation.getString("layerName");
    
    int numberOfChildren = 1;
    if (!spawnInformation.isNull("count")) {
      numberOfChildren = spawnInformation.getInt("count");
    }
    
    for (int j = 0; j < numberOfChildren; j++) {
      Bloon newBloon = new Bloon(layerName, position);
      setModifiers(spawnInformation, newBloon);
      createdBloonQueue.add(newBloon);
      
      createdBloons.add(newBloon);
    }
    
    return createdBloons;
  }
  
  public ArrayList<Bloon> spawn(JSONObject spawnInformation) {
    ArrayList<Bloon> createdBloons = new ArrayList<Bloon>();
    
    String layerName = spawnInformation.getString("layerName");
    
    int numberOfChildren = 1;
    if (!spawnInformation.isNull("count")) {
      numberOfChildren = spawnInformation.getInt("count");
    }
    
    for (int j = 0; j < numberOfChildren; j++) {
      Bloon newBloon = new Bloon(layerName);
      setModifiers(spawnInformation, newBloon);
      createdBloonQueue.add(newBloon);
      
      createdBloons.add(newBloon);
    }
    
    return createdBloons;
  }
  
  // Actually spawns the bloons
  public void emptyQueue() {
    for (Bloon bloon : createdBloonQueue) {
      // If we've killed the bloon to trigger the children spawn because we did a lot of damage
      if (bloon.shouldRemove()) {
        continue;
      }
      
      game.bloons.add(bloon);
    }
    
    createdBloonQueue.clear();
  }
  
}
