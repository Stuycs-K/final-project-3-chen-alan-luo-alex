public class Game{
    private Map map;
    private ArrayList<Tower> towers;
    private ArrayList<Bloon> bloons;
    private int currency;
    private int health;
    private boolean gameActive;

    public Game() {
        ArrayList<PVector> waypoints = new ArrayList<PVector>();
        waypoints.add(new PVector(0, 500));
        waypoints.add(new PVector(500, 500));
        waypoints.add(new PVector(500, 250));
        waypoints.add(new PVector(750, 250));
      
        map = new Map(waypoints, 5);
        towers = new ArrayList<>();
        bloons = new ArrayList<>();
        currency = 100;
        health = 100;
        gameActive = true;
    }

    public void startGame(){

    }
    public void update(){
        
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
