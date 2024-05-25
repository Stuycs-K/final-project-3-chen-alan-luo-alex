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
    //MapSegment segment = game.getMap().getMapSegmentFromPosition(startPosition);
    
    for (int j = 0; j < numberOfChildren; j++) {
      float distanceOffset = spawnSpacing * j; // The first child will spawn in the exact same position; subsequent bloons will spawn behind
      
      int currentSegmentId = currentMapSegmentId;
      PVector finalSpawnPosition = startPosition.copy();
      
      while (true) {
        MapSegment currentSegment = game.getMap().getMapSegment(currentSegmentId);
        
        // Direction to move from the original spawn position
        PVector direction = PVector.sub(currentSegment.end, currentSegment.start).normalize();
        direction.mult(distanceOffset);
        
        // Try to move by distance; if we're outside the current map segment, move the child bloon to the previous map segment
        PVector resultSpawnPosition = PVector.add(finalSpawnPosition, direction);
        
        // This would spawn the bloon too far back, so try again with the previous segment
        if (!currentSegment.isBetweenStartAndEnd(resultSpawnPosition)) {
          float distanceToStart = PVector.dist(finalSpawnPosition, currentSegment.start);
          finalSpawnPosition = currentSegment.start.copy();
          
          distanceOffset -= distanceToStart;
          
          // Go to the previous map segment
          currentSegmentId -= 1;
          
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
    int numberOfChildren = childrenSpawnInformation.getInt("count");
    
    for (int j = 0; j < numberOfChildren; j++) {
      Bloon newBloon = new Bloon(layerName, position);
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
