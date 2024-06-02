public class Game{
  private Map map;
  public ArrayList<Tower> towers;
  public ArrayList<Bloon> bloons;
  private HealthManager healthManager;
  private CurrencyManager currencyManager;
  private boolean gameActive;
  
  private float currencyPerPopMultiplier;
  
  public WaveManager waveManager;
  private Tower selectedTower;
  private boolean showTowerOptions;
  
  private TextButton upgradeButton;
  private TextButton sellButton;
  
  private ImageLabel towerImage;
  
  private TextLabel upgradeLabel;
  private TextLabel sellLabel;
  private TextLabel towerLabel;
  private TextLabel path1Label;
  private TextLabel path2Label;
  
  private Frame horizontalWoodenPadding;
  private Frame verticalWoodenPadding;
  
  private ImageButton towerButtonDartMonkey;
  private ImageButton path1Button;
  private ImageButton path2Button;

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
    gameActive = true;
    
    currencyPerPopMultiplier = 1;
    
    healthManager = new HealthManager(200);
    currencyManager = new CurrencyManager();
    
    waveManager = new WaveManager();
    
    showTowerOptions = false;
    setupGui();
  }
  
  public Map getMap() {
    return map;
  }
  
  public CurrencyManager getCurrencyManager() {
    return currencyManager;
  }
  
  public float getCurrencyPerPopMultiplier() {
    return currencyPerPopMultiplier;
  }

  public void startGame(){
    waveManager.setWave(0);
    waveManager.startNextWave();
    currencyManager.setCurrency(650);
  }
  
   public void update(){
    if (healthManager.didLose()) {
      waveManager.removeWaves();
      println("YOU LOSE");
      return;
    }
    // TODO
    if (waveManager.waveFinishedSpawning()) {
      
      if (waveManager.isLastWave()) {
        return;
      }
      
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
    }
    // Remove bloons that need to be removed
    bloons.removeAll(scheduledForRemoval);
    
    
   
    
    for(Tower tower: towers){
      tower.step(bloons);
      //tower.attack(bloons);
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
    upgradeButton = (TextButton) guiManager.create("upgradeButton");
    sellButton = (TextButton) guiManager.create("sellButton");
    upgradeLabel = (TextLabel) guiManager.create("upgradeLabel");
    sellLabel = (TextLabel) guiManager.create("sellLabel");
    towerLabel = (TextLabel) guiManager.create("towerLabel");
    horizontalWoodenPadding = (Frame) guiManager.create("horizontalWoodenPadding");
    verticalWoodenPadding = (Frame) guiManager.create("verticalWoodenPadding");
    towerButtonDartMonkey = (ImageButton) guiManager.create("towerButtonDartMonkey");
    //towerButton = (ImageButton) guiManager.create("towerButton");
    towerImage = (ImageLabel) guiManager.create("towerImage");
    path1Button = (ImageButton) guiManager.create("path1Button");
    path1Label = (TextLabel) guiManager.create("path1Label");
    path2Button = (ImageButton) guiManager.create("path2Button");
    path2Label = (TextLabel) guiManager.create("path2Label");
    
    
   }
  
  public void placeTower(String towerName, int x, int y){
    int startingCost = towerPropertyLookup.getTowerProperties(towerName).getBaseCost();
    
     if(towerName.equals("DartMonkey")){
      DartMonkey dartMonkey = new DartMonkey(x, y);
      towers.add(dartMonkey);
    }
   
     if (towerName.equals("BombShooter")){
       BombShooter bombShooter = new BombShooter(x,y);
       towers.add(bombShooter);
     }
  }
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
  public void selectTower(Tower tower){
    selectedTower = tower;
    showTowerOptions = true;
  }

  public void render() {
    map.drawPath();
    for (Tower tower: towers){
      //println("Drawing tower at: " + tower.x + ", " + tower.y);
      tower.draw();
    }
    guiManager.render();
  }
  
  public void mousePressed(int mx, int my) {
    // need to add hitbox so that 

    //PVector mousePosition = new PVector(mx, my);
    //MapSegment mapSegment = map.getMapSegmentFromPosition(mousePosition);
    
    //if(mapSegment == null){
    //  return;
    //}
    
    /*
    for (Tower tower : towers) {
      tower.upgrade(0); 
    }*/
    
    if (upgradeButton.isMouseInBounds()) {
      if (selectedTower != null) {
         selectedTower.upgrade(0);
      }
       return;
      }
     
     
    if (sellButton.isMouseInBounds()) {
      if (selectedTower != null) {
         selectedTower.sellTower();
      }
       return;
     }

    for (Tower tower : towers) {
      if (isInBoundsOfRectangle(mouseX, mouseY, tower.x, tower.y, tower.sprite.width, tower.sprite.height)) {
        selectTower(tower);
        return;
      }
    }
   
    placeTower("DartMonkey", mx, my);
  }

}

public class UpgradeButton {
  
}
