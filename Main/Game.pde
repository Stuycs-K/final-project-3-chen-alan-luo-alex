public class Game{
    private Map map;
    public ArrayList<Tower> towers;
    public ArrayList<Bloon> bloons;
    private int currency;
    private int health;
    private boolean gameActive;
    
    public WaveManager waveManager;

    public Game() {
        ArrayList<PVector> waypoints = new ArrayList<PVector>();
        waypoints.add(new PVector(0, 100));
        waypoints.add(new PVector(500, 300));
        waypoints.add(new PVector(500, 100));
        waypoints.add(new PVector(750, 100));
        waypoints.add(new PVector(1000, 400));
        waypoints.add(new PVector(1000, 600));
        waypoints.add(new PVector(800, 600));
        waypoints.add(new PVector(800, 400));
        waypoints.add(new PVector(300, 400));
        waypoints.add(new PVector(300, 700));
        waypoints.add(new PVector(500, 700));
        waypoints.add(new PVector(500, 550));
      
        map = new Map(waypoints, 7);
        towers = new ArrayList<>();
        bloons = new ArrayList<>();
        currency = 100;
        health = 100;
        gameActive = true;
        
        waveManager = new WaveManager();
    }
    
    public Map getMap() {
      return map;
    }

    public void startGame(){
      waveManager.setWave(1);
      waveManager.startNextWave();
    }
    
    public void update(){
      // TODO
      if (waveManager.waveFinishedSpawning()) {
        waveManager.startNextWave();
      }
      
      ArrayList<Bloon> scheduledForRemoval = new ArrayList<Bloon>();
      for(int i = bloons.size() -1; i>= 0; i--){
        Bloon bloon = bloons.get(i);
        if(bloon.shouldRemove()){
          scheduledForRemoval.add(bloon);
        }else{
          bloon.step();
          if(frameCount % 150 ==0){
            bloon.damage(1);
          }
        }
      }
      //for (Bloon bloon : bloons) {
      //  if (bloon.shouldRemove()) {
      //    scheduledForRemoval.add(bloon);
      //    continue;
      //  }
        
      //  bloon.step();
        
      //  if (frameCount % 150 == 0) {
      //    bloon.damage(1); 
      //  }
      //}
      //// Remove bloons that need to be removed
      bloons.removeAll(scheduledForRemoval);
      
     
      
      for(Tower tower: towers){
        tower.attack(bloons);
        ArrayList<Projectile> projectilesToRemove = new ArrayList<>();
        for(Projectile projectile : tower.projectiles){
          projectile.update(bloons);
          if(projectile.finished){
            projectilesToRemove.add(projectile);
          }
        }
        tower.projectiles.removeAll(projectilesToRemove);
      }
      
      // Insert all bloons that have been created
      bloonSpawner.emptyQueue();
      
      
    }
    
    public void placeTower(String towerName, int x, int y){
      Tower newTower = null;
      println("Attempting to place tower: " + towerName + " at (" + x + "," + y + ")");
      if(towerName.equals("DartMonkey")){
        newTower = new DartMonkey(x,y);
      }else if (towerName.equals("BombShooter")){
        newTower = new BombShooter(x,y);
      }else if (towerName.equals("IceMonkey")){
        newTower = new IceMonkey(x,y);
      }else if(towerName.equals("SuperMonkey")){
        newTower = new SuperMonkey(x,y);
      }
      
      if(newTower != null){
        //println("New tower cost: " + newTower.getCost() + ", current currency: " + currency);
        //if(currency >= newTower.getCost()){
          towers.add(newTower);
        //  currency -= newTower.getCost();
          //println("tower placed at: " + x + "," + y);
      //}else{
      //  println("not enough money");
      //}
      }else{
        println("tower failed to place");
      }
    }

    
    public Tower selectTower(int x, int y){
        return null;
    }
    public void sellTower(Tower towerName, int x, int y){

    }
    public void towerUpgrade(Tower tower){

    }
    public void removeBloon(Bloon bloon){
      bloons.remove(bloon);
    }
    
    public void render() {
      
      map.drawPath();
      for (Tower tower: towers){
        //println("Drawing tower at: " + tower.x + ", " + tower.y);
        tower.draw();
    }
    }
}
