import java.util.Set;

private class WaveSpawn extends Thread {
  private String name;
  private JSONObject waveSpawnInformation;
  private HashMap<String, WaveSpawn> otherWaveSpawns;
  
  private boolean finishedSpawning;

  public WaveSpawn(String name, JSONObject waveSpawnInformation, HashMap<String, WaveSpawn> otherWaveSpawns) {
    this.name = name;
    this.waveSpawnInformation = waveSpawnInformation;
    this.otherWaveSpawns = otherWaveSpawns;
    
    this.finishedSpawning = false;
  }
  
  public boolean finishedSpawning() {
    return finishedSpawning;
  }
  
  private void spawn() {
    int count = waveSpawnInformation.getInt("count");
    String layerName = waveSpawnInformation.getString("layerName");
    JSONObject modifiers = waveSpawnInformation.getJSONObject("modifiers");
    long timeBetweenSpawns = (long) (waveSpawnInformation.getFloat("timeBetweenSpawns") * 1000);
    
    JSONObject bloonSpawnInformation = new JSONObject();
    bloonSpawnInformation.setString("layerName", layerName);
    if (modifiers != null) {
      bloonSpawnInformation.setJSONObject("modifiers", modifiers);
    } 
    
    try {
      for (int i = 0; i < count; i++) {
        bloonSpawner.spawn(bloonSpawnInformation);
        Thread.sleep(timeBetweenSpawns);
      }
    } catch (InterruptedException exception) {
      finishedSpawning = true;
      return;
    }
   
    finishedSpawning = true;
  }
  
  public void run() {
    try {
      while (!interrupted() || !finishedSpawning) {
        Thread.sleep(100);
        
        // Do we need to wait for any other thread?
        if (!waveSpawnInformation.isNull("waitForAllSpawned")) {
          String subwaveName = waveSpawnInformation.getString("waitForAllSpawned");
          WaveSpawn subwave = otherWaveSpawns.get(subwaveName);
          
          // Not finished spawning, so keep waiting
          if (!subwave.finishedSpawning()) {
            continue;
          }
        }
        
        if (!waveSpawnInformation.isNull("waitBeforeSpawning")) {
          float delaySeconds = waveSpawnInformation.getFloat("waitBeforeSpawning");
          Thread.sleep((long) (delaySeconds * 1000));
        }
        
        spawn();
        break;
      }
    } catch (InterruptedException exception) {
      
    }
    
  }
}

public class WaveManager {
  private JSONArray waveStructure;
  private int currentWaveNumber;
  
  private JSONObject currentWave;
  
  private HashMap<String, WaveSpawn> currentWaveSpawns;
  
  public WaveManager() {
    this.waveStructure = loadJSONArray("waves.json");
    this.currentWaveNumber = 0;
    this.currentWave = null;
    this.currentWaveSpawns = new HashMap<String, WaveSpawn>();
  }
  
  public void startNextWave() {
    currentWaveNumber++;
    
    currentWaveSpawns.clear();
    
    currentWave = waveStructure.getJSONObject(currentWaveNumber);
    spawnWave();
  }
  
  public void stopAllWaves() {
    for (WaveSpawn waveSpawn : currentWaveSpawns.values()) {
      waveSpawn.interrupt();
    }
  }
  
  private void spawnWave() {
    if (currentWave == null) {
      return; 
    }
    JSONObject spawns = currentWave.getJSONObject("spawns");
    
    Set<String> keySet = spawns.keys();
    for (String keyName : keySet) {
      WaveSpawn waveSpawn = new WaveSpawn(keyName, spawns.getJSONObject(keyName), currentWaveSpawns);
      currentWaveSpawns.put(keyName, waveSpawn);
    }
    
    for (WaveSpawn waveSpawn : currentWaveSpawns.values()) {
      waveSpawn.start();
    }
  }
  
  public int getCurrentWaveNumber() {
    return currentWaveNumber;
  }
}
