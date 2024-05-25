public class BloonSpawner {
  public static final int CHILDREN_SPAWN_SPACING = 25;
  
  ArrayList<Bloon> createdBloonQueue;
  
  public BloonSpawner() {
    createdBloonQueue = new ArrayList<Bloon>();
  }
  
  public void spawnChildren(JSONObject childrenSpawnInformation, PVector startPosition) {
    String layerName = childrenSpawnInformation.getString("layerName");
    int numberOfChildren = childrenSpawnInformation.getInt("count");
    String spawnSpacingString = childrenSpawnInformation.getString("spacing");
    
    int spawnSpacing = CHILDREN_SPAWN_SPACING;
    if (spawnSpacingString != null) {
      spawnSpacing = Integer.parseInt(spawnSpacingString); 
    }
    
    // Get segments
    int currentMapSegmentId = game.getMap().getSegmentIdFromPosition(startPosition);

    for (int j = 0; j < numberOfChildren; j++) {
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
      
    }
  }
  
  public void spawn(JSONObject childrenSpawnInformation, PVector position) {
    String layerName = childrenSpawnInformation.getString("layerName");
    
    int numberOfChildren = 1;
    if (!childrenSpawnInformation.isNull("count")) {
      numberOfChildren = childrenSpawnInformation.getInt("count");
    }
    
    for (int j = 0; j < numberOfChildren; j++) {
      Bloon newBloon = new Bloon(layerName, position);
      createdBloonQueue.add(newBloon);
    }
  }
  
  public void spawn(JSONObject childrenSpawnInformation) {
    String layerName = childrenSpawnInformation.getString("layerName");
    
    int numberOfChildren = 1;
    if (!childrenSpawnInformation.isNull("count")) {
      numberOfChildren = childrenSpawnInformation.getInt("count");
    }
    
    for (int j = 0; j < numberOfChildren; j++) {
      Bloon newBloon = new Bloon(layerName);
      createdBloonQueue.add(newBloon);
    }
  }
  
  // Actually spawns the bloons
  public void emptyQueue() {
    for (Bloon bloon : createdBloonQueue) {
      game.bloons.add(bloon);
    }
    
    createdBloonQueue.clear();
  }
  
}
