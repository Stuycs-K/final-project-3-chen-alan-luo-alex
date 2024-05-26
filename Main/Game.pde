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
        
        if (frameCount % 40 == 0) {
          bloon.damage(2); 
        }
      }
      // Remove bloons that need to be removed
      bloons.removeAll(scheduledForRemoval);
      
      // Insert all bloons that have been created
      bloonSpawner.emptyQueue();
    }
    public void placeTower(String towerName, int x, int y){
      Tower newTower = null;
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
        println("New tower cost: " + newTower.getCost() + ", current currency: " + currency);
        if(currency >= newTower.getCost()){
          towers.add(newTower);
          currency -= newTower.getCost();
          println("tower placed at: " + x + "," + y);
      }else{
        println("not enough money");
      }
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
    
    public void render() {
      map.drawPath();
      for (Tower tower: towers){
        println("Drawing tower at: " + tower.x + ", " + tower.y);
        tower.draw();
    }
    }
}
