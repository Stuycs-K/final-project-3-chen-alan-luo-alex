public class Game{
    private Map map;
    private ArrayList<Tower> towers;
    private ArrayList<Bloon> bloons;
    private int currency;
    private int health;
    private boolean gameActive;

    public Game(){
        map = new Map();
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

    }
    public void sellTower(Tower towerName, int x, int y){

    }
    public void towerUpgrade(Tower tower){

    }

}
