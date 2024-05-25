public class Game{
    private Map map;
    public ArrayList<Tower> towers;
    public ArrayList<Bloon> bloons;
    private int currency;
    private int health;
    private boolean gameActive;

    public Game() {
        ArrayList<PVector> waypoints = new ArrayList<PVector>();
        waypoints.add(new PVector(0, 500));
        waypoints.add(new PVector(500, 500));
        waypoints.add(new PVector(500, 250));
        waypoints.add(new PVector(750, 250));
        waypoints.add(new PVector(1000, 500));
      
        map = new Map(waypoints, 5);
        towers = new ArrayList<>();
        bloons = new ArrayList<>();
        currency = 100;
        health = 100;
        gameActive = true;
    }
    
    public Map getMap() {
      return map;
    }

    public void startGame(){

    }
    public void update(){
      ArrayList<Bloon> scheduledForRemoval = new ArrayList<Bloon>();
      for (Bloon bloon : bloons) {
        if (bloon.shouldRemove()) {
          scheduledForRemoval.add(bloon);
          continue;
        }
        
        bloon.step();
        
        if (frameCount % 20 == 0) {
          bloon.damage(1); 
        }
      }
      // Remove bloons that need to be removed
      bloons.removeAll(scheduledForRemoval);
      
      // Insert all bloons that have been created
      bloonSpawner.emptyQueue();
    }
    public void placeTower(String towerName, int x, int y){

    }
    public Tower selectTower(int x, int y){
        return null;
    }
    public void sellTower(Tower towerName, int x, int y){

    }
    public void towerUpgrade(Tower tower){

    }
    
    public void render() {
      map.drawPath();
    }

}
