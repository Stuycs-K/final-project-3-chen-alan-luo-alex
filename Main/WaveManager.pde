import java.util.Set;

private class WaveSpawn {
  private String name;
  private JSONObject waveSpawnInformation;
  private HashMap<String, WaveSpawn> otherWaveSpawns;

  public WaveSpawn(String name, JSONObject waveSpawnInformation, HashMap<String, WaveSpawn> otherWaveSpawns) {
    this.name = name;
    this.waveSpawnInformation = waveSpawnInformation;
    this.otherWaveSpawns = otherWaveSpawns;
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
  }
  
  public int getCurrentWaveNumber() {
    return currentWaveNumber;
  }
}
