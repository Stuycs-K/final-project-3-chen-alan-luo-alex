public class Game{
    private Map map;
    public ArrayList<Tower> towers;
    public ArrayList<Bloon> bloons;
    private int currency;
    private HealthManager healthManager;
    private int health;
    private boolean gameActive;
    
    public WaveManager waveManager;
    private Tower selectedTower;
    private boolean showTowerOptions;
    private GuiManager guiManager;
    private Button upgradeButton;
    private Button sellButton;

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
        
        healthManager = new HealthManager(200);
        
        waveManager = new WaveManager();
        
        showTowerOptions = false;
        guiManager = new GuiManager();
        setupGui();
    }
    
    public Map getMap() {
      return map;
    }

    public void startGame(){
      waveManager.setWave(1);
      waveManager.startNextWave();
    }
    
     public void update(){
      if (healthManager.didLose()) {
        waveManager.stopAllWaves();
        println("YOU LOSE");
        return;
      }
      // TODO
      if (waveManager.waveFinishedSpawning()) {
        waveManager.startNextWave();
      }
      
      ArrayList<Bloon> scheduledForRemoval = new ArrayList<Bloon>();
      for (Bloon bloon : bloons) {
        if (bloon.shouldRemove()) {
          scheduledForRemoval.add(bloon);
          
          if (bloon.reachedEnd()) {
            healthManager.takeDamageFromBloon(bloon); 
          }
          
          continue;
        }
        
        bloon.step();
        
        //if (frameCount % 150 == 0) {
        //  bloon.damage(1); 
        //}
      }
      // Remove bloons that need to be removed
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
    
    private void setupGui(){
      upgradeButton = (Button) guiManager.create("upgradeButton");
      sellButton = (Button) guiManager.create("sellButton");
      
    }

    private void updateGuiPositions(Tower tower){
      float buttonX = tower.getTowerX() + 50;
      float buttonY = tower.getTowerY();
    }
    
    public void placeTower(String towerName, int x, int y){
       if(towerType.equals("DartMonkey")){
        DartMonkey dartMonkey = new DartMonkey(x, y);
        towers.add(dartMonkey);
      }
      //}else if (towerName.equals("BombShooter")){
      //  newTower = new BombShooter(x,y);
      //}else if (towerName.equals("IceMonkey")){
      //  newTower = new IceMonkey(x,y);
      //}else if(towerName.equals("SuperMonkey")){
      //  newTower = new SuperMonkey(x,y);
        
      
   
        //println("New tower cost: " + newTower.getCost() + ", current currency: " + currency);
        //if(currency >= newTower.getCost()){
       
        //  currency -= newTower.getCost();
          //println("tower placed at: " + x + "," + y);
      //}else{
      //  println("not enough money");
      //}
      
       
    }

    
    public Tower selectTower(Tower tower){
      selectedTower = tower;
      showTowerOptions = true;
      updateGuiPostions(tower);
    }
    public void sellTower(Tower towerName, int x, int y){

    }
    public void towerUpgrade(Tower tower){

    }

    public void render() {
      
      map.drawPath();
      for (Tower tower: towers){
        //println("Drawing tower at: " + tower.x + ", " + tower.y);
        tower.draw();
    }
      if(showTowerOptions && selectedTower != null){
        guiManager.render();
      }
     
    }
    
    private boolean isMouseOverButton(Button button, int mx, int my){
      PVector buttonPos = button.getPosition();
      PVector buttonSize = button.getSize();
      
      return mx > buttonPos.x && mx < buttonPos.x + buttonSize.x &&  my > buttonPos.y && my < buttonPos.y + buttonSize.y;
    }
    
    public void mousePressed(int mx, int my) {
     if (showTowerOptions) {
       if (isMouseOverButton(upgradeButton, mx, my)) {
         selectedTower.upgrade(selectedTower.path);
         showTowerOptions = false;
         selectedTower = null;
         return;
       }

       if (isMouseOverButton(sellButton, mx, my)) {
         selectedTower.sellTower(this);
         showTowerOptions = false;
         selectedTower = null;
         return;
       }
      }
    for (Tower tower : towers) {
        if (dist(mx, my, tower.getTowerX(), tower.getTowerY()) < tower.radius) {
         selectTower(tower);
          return;
       }
     }

        placeTower("DartMonkey", mx, my);
    }
    

}
