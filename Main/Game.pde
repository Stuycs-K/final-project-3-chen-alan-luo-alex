public class Game{
  private Map map;
  public ArrayList<Tower> towers;
  public ArrayList<Bloon> bloons;
  public ArrayList<Projectile> projectiles;
  private HealthManager healthManager;
  private CurrencyManager currencyManager;
  private boolean gameActive;
  
  private float currencyPerPopMultiplier;
  
  public WaveManager waveManager;
  private Tower selectedTower;
  private boolean showTowerOptions;

  private TextButton sellButton;
  
  private ImageLabel towerImage;
  
  private TextLabel sellLabel;
  private TextLabel towerLabel;
  private TextLabel path1Label;
  private TextLabel path2Label;
  
  private Frame horizontalWoodenPadding;
  private Frame verticalWoodenPadding;
  
  private ImageButton towerButtonDartMonkey;
  private ImageButton towerButtonBombShooter;
  private ImageButton path1Button;
  private ImageButton path2Button;
  
  private String currentTowerType = null;
  private TextLabel placementLabel;

  private PImage invalidUpgradeImage;
  
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
    projectiles = new ArrayList<Projectile>();
    gameActive = true;
    
    currencyPerPopMultiplier = 1;
    
    healthManager = new HealthManager(200);
    currencyManager = new CurrencyManager();
    
    waveManager = new WaveManager();
    
    invalidUpgradeImage = loadImage("images/upgradeIcons/invalidUpgrade.png");
    showTowerOptions = false;
    setupGui();
  }
  
  public Map getMap() {
    return map;
  }
  
  public void setCurrentTower(String towerType){
    this.currentTowerType = towerType;
    updatePlacingLabel("Now placing: " + towerType);
  }
  
  private void updatePlacingLabel(String text){
    if(placementLabel != null){
      placementLabel.setText(text);
      placementLabel.setVisible(true);
    }
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
    if (waveManager.waveFinishedSpawning() && bloons.isEmpty()) {
      
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
    
    // Any random untracked projectile
    ArrayList<Projectile> projectileScheduled = new ArrayList<>();
    for (Projectile projectile : projectiles) {
      projectile.update(bloons);
      if(projectile.finished) {
        projectileScheduled.add(projectile);
      }
    }
    projectiles.removeAll(projectileScheduled);
   
    
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
    sellButton = (TextButton) guiManager.create("sellButton");
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
    placementLabel = (TextLabel) guiManager.create("placementLabel");
    towerButtonDartMonkey = (ImageButton) guiManager.create("towerButtonBombShooter");
    
    
   }
  
  public void placeTower(String towerName, int x, int y){
    if(!map.isOnPath(new PVector(x,y)) && currentTowerType != null){
      
      int startingCost = towerPropertyLookup.getTowerProperties(towerName).getBaseCost();
    
      Tower newTower = null;
      if(towerName.equals("DartMonkey")){
        newTower = new DartMonkey(x,y);
        if(currencyManager.getCurrency() > startingCost){
          currencyManager.removeCurrency(startingCost);
        }
      }else if(towerName.equals("BombShooter")){
        newTower = new BombShooter(x,y);
        if(currencyManager.getCurrency() > startingCost){
          currencyManager.removeCurrency(startingCost);
        }
   
    }
     if(newTower != null){
       towers.add(newTower);
       selectedTower = null;
       currentTowerType = null;
       placementLabel.setVisible(false);
     }
      
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
    displayTowerDetails(selectedTower);
  }
  
  private void displayTowerDetails(Tower tower){
    
    if(tower!=null){
      String towerName = tower.towerName;

      ArrayList<TowerUpgrade> nextUpgrades = tower.upgrades.getNextUpgrades();
      
      towerImage.setImage(tower.getSprite());
      
      TowerUpgrade nextPath1Upgrade = nextUpgrades.get(0);
      TowerUpgrade nextPath2Upgrade = nextUpgrades.get(1);
      
      if(nextPath1Upgrade!=null){
        path1Button.setImage(nextPath1Upgrade.getUpgradeImage());
        path1Label.setText("Path 1" + nextPath1Upgrade.getUpgradeName());
        
      }else{
        path1Button.setImage(invalidUpgradeImage);
        path1Label.setText("Path 1: No Upgrade");
      }
      
      if(nextPath2Upgrade != null){
        path2Button.setImage(nextPath2Upgrade.getUpgradeImage());
        path2Label.setText("Path 2" + nextPath2Upgrade.getUpgradeName());
      }else{
        path2Button.setImage(invalidUpgradeImage);
        path2Label.setText("Path 2: No upgrade");
      }
      sellButton.setVisible(true);
      sellLabel.setVisible(true);
    }else{
      sellButton.setVisible(false);
      sellLabel.setVisible(false);
    }

  }
  


  public void render() {
    map.drawPath();
    for (Tower tower: towers){
      //println("Drawing tower at: " + tower.x + ", " + tower.y);
      tower.draw();
      if(tower==selectedTower && currentTowerType == null){
        drawHighlightCircle(tower.x, tower.y);
      }
    }
    
    for (Projectile projectile : projectiles) {
      projectile.drawProjectile();
    }
  }
  
  private void drawHighlightCircle(int x, int y){
    stroke(255,204,0);
    noFill();
    ellipse(x,y,100,100);
  }
  
  public void mousePressed(int mx, int my) {
   if (currentTowerType != null && !guiManager.mousePressed()) {
      placeTower(currentTowerType, mx, my);
      return;
        }
     else if (isInBoundsOfRectangle(mx, my, 650,675, 150, 50)) {
          if (selectedTower != null) {
            selectedTower.sellTower();
            selectedTower = null;
            displayTowerDetails(null);
            }
        }

     if (isInBoundsOfRectangle(mx, my, 820, 700, 100, 100) && selectedTower !=  null) {
        selectedTower.upgrade(0);  
        displayTowerDetails(selectedTower);
       // currencyManager.rewardCurrency
        
      } else if (isInBoundsOfRectangle(mx, my, 940, 700, 100, 100) && selectedTower != null) {
          selectedTower.upgrade(1);  
            displayTowerDetails(selectedTower); 
        }
    
    

    for (Tower tower : towers) {
      if (isInBoundsOfRectangle(mouseX, mouseY, tower.x, tower.y, tower.sprite.width, tower.sprite.height)) {
        selectTower(tower);
        return;
      }
    }
    

    
  

}


    }
    

public class UpgradeButton {
  
}
