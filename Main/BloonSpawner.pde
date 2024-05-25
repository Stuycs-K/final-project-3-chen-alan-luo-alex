public class BloonSpawner {
  ArrayList<Bloon> createdBloonQueue;
  
  public BloonSpawner() {
    createdBloonQueue = new ArrayList<Bloon>();
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
