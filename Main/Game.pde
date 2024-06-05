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

  private String currentTowerType = null;
  private TextLabel placementLabel;

  private PImage invalidUpgradeImage;
  
  private UpgradePanel upgradePanel;
  private TowerSelectionPanel towerSelectionPanel;
  
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
    upgradePanel = new UpgradePanel();
    upgradePanel.setVisible(false);
    
    towerSelectionPanel = new TowerSelectionPanel();

    placementLabel = (TextLabel) guiManager.create("placementLabel");
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
    upgradePanel.onTowerSelect(selectedTower);
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
    
    for (Tower tower : towers) {
      if (isInBoundsOfRectangleCentered(mouseX, mouseY, tower.x, tower.y, tower.sprite.width, tower.sprite.height)) {
        selectTower(tower);
        return;
      }
    }
    

    selectedTower = null;
    upgradePanel.onTowerDeselect();
  }
}
    
// UPGRADE PANEL

/*
Upgrade panel contains one image label that displays the tower's current sprite, two upgrade buttons, and a sell button
*/
public class UpgradePanel {
  private class SellButton extends TextButton {
    private Tower currentTower;
    
    public SellButton(JSONObject definition) {
      super(definition);
    }
 
    public void setCurrentTower(Tower tower) {
      this.currentTower = tower;
    }
    
    public void onInput() {
      if (currentTower == null) {
        return;
      }
      
      currentTower.sellTower();
      game.upgradePanel.onTowerDeselect();
      
      currentTower = null;
      // Remove money
    }
    
  }
  
  private static final int UPGRADE_BUTTON_PADDING = 45;
  
  private Frame backgroundFrame;
  private TextLabel towerNameLabel;
  private ImageLabel towerSprite;
  private ArrayList<UpgradeButton> upgradeButtons;
  private SellButton sellButton;
  
  public UpgradePanel() {
    this.backgroundFrame = (Frame) guiManager.create("horizontalWoodenPadding");
    this.towerNameLabel = (TextLabel) guiManager.create("towerNameLabel");
    this.towerSprite = (ImageLabel) guiManager.create("towerImage");
    
    this.sellButton = new SellButton(guiManager.getGuiDefinition("sellButton"));
    guiManager.createCustom((GuiBase) this.sellButton);
    
    this.upgradeButtons = new ArrayList<UpgradeButton>();
    
    for (int i = 0; i < 2; i++) {
      // Stupid way of getting the buttons to lay out in a list
      // No way I'm writing some list class for this
      
      UpgradeButton newUpgradeButton = new UpgradeButton(i);
      
      // Starting X position
      int positionX = int(newUpgradeButton.imageButton.position.x);
      positionX += (newUpgradeButton.imageButton.size.x + UPGRADE_BUTTON_PADDING) * i;
      
      newUpgradeButton.setPosition(new PVector(positionX, newUpgradeButton.imageButton.position.y));
      
      this.upgradeButtons.add(newUpgradeButton);
    }
  }
  
  public void setVisible(boolean state) {
    backgroundFrame.setVisible(state);
    towerSprite.setVisible(state);
    sellButton.setVisible(state);
    
    for (UpgradeButton button : upgradeButtons) {
      button.setVisible(state);
    }
  }
  
  public void onTowerSelect(Tower tower) {
    setVisible(true);
    displayTowerInformation(tower);
  }
  
  public void onTowerUpgrade(Tower tower) {
    onTowerSelect(tower);
  }
  
  public void onTowerDeselect() {
    displayTowerInformation(null);
  }
  
  public void displayTowerInformation(Tower tower) {
    sellButton.setCurrentTower(tower);
    for (UpgradeButton button : upgradeButtons) {
      button.setTower(tower);
    }
    
    if (tower == null) {
      setVisible(false);
      return;
    }
    
    towerNameLabel.setText(tower.towerName);
    towerSprite.setImage(tower.getSprite());
  }
}
  
public class UpgradeButton {
  private class UpgradeImageButton extends ImageButton {
    private Tower currentTower;
    private int pathId;
    
    public UpgradeImageButton(JSONObject definition) {
      super(definition);
      this.currentTower = null;
    }
    
    public void setPathId(int pathId) {
      this.pathId = pathId;
    }
    
    public void setCurrentTower(Tower tower) {
      this.currentTower = tower;
      
      if (tower == null) {
        this.clearImage();
      }
    }
    
    public void onInput() {
      if (currentTower == null) {
        return;
      }
      
      currentTower.upgrade(pathId);
      game.upgradePanel.onTowerUpgrade(currentTower);
      // Remove money
    }
  }

  private TextLabel upgradeNameLabel;
  private TextLabel costLabel;
  public UpgradeImageButton imageButton;
  
  private Tower currentTower;
  private int pathId;
  
  public UpgradeButton(int pathId) {
    this.upgradeNameLabel = (TextLabel) guiManager.create("upgradeLabel");
    this.costLabel = (TextLabel) guiManager.create("upgradeLabel");
    
    this.imageButton = new UpgradeImageButton(guiManager.getGuiDefinition("pathImageButton"));
    guiManager.createCustom((GuiBase) this.imageButton);
    
    PVector upgradeNamePosition = new PVector(this.imageButton.position.x, this.imageButton.position.y - 5);
    this.upgradeNameLabel.setPosition(upgradeNamePosition);
    
    PVector costLabelPosition = new PVector(this.imageButton.position.x, this.imageButton.position.y + this.imageButton.size.y);
    this.costLabel.setPosition(costLabelPosition);
    
    this.pathId = pathId;
    this.imageButton.setPathId(pathId);
  }
  
  public void setVisible(boolean state) {
    upgradeNameLabel.setVisible(state);
    costLabel.setVisible(state);
    imageButton.setVisible(state);
  }
  
  public void setPosition(PVector position) {
    int deltaX = int(position.x - imageButton.position.x);
    int deltaY = int(position.y - imageButton.position.y);
    
    imageButton.setPosition(position);
    upgradeNameLabel.translatePosition(deltaX, deltaY);
    costLabel.translatePosition(deltaX, deltaY);
  }
  
  public void setTower(Tower tower) {
    if (tower == null) {
      currentTower = null;
      imageButton.setCurrentTower(null);
      upgradeNameLabel.setText("");
      costLabel.setText("");
      
      setVisible(false);
      
      return;
    }
    currentTower = tower;
    imageButton.setCurrentTower(currentTower);
    
    TowerUpgradeManager upgrades = tower.upgrades;
    TowerUpgrade nextUpgrade = upgrades.getNextUpgrades().get(pathId);
    
    // Upgrade doesn't exist
    if (nextUpgrade == null) {
      imageButton.setImage(INVALID_UPGRADE_IMAGE);
      upgradeNameLabel.setText("Path locked");
      costLabel.setText("");
      
      return;
    }
    
    imageButton.setImage(nextUpgrade.getUpgradeImage());
    upgradeNameLabel.setText(nextUpgrade.getUpgradeName());
    costLabel.setText("$" + nextUpgrade.getUpgradeCost());
  }
}

// TOWER SEELCTION SIDEBAR

public class TowerSelectionPanel {
  private static final int ROW_PADDING = 5;
  private static final int COLUMN_PADDING = 5;
  private static final int TOWER_BUTTONS_PER_ROW = 2;
  
  private ArrayList<TowerSelectButton> buttons;
  private Frame verticalBackground;
  private TextLabel header;
  
  public TowerSelectionPanel() {
    this.buttons = new ArrayList<TowerSelectButton>();
    this.verticalBackground = (Frame) guiManager.create("verticalWoodenPadding");
    this.header = (TextLabel) guiManager.create("towerLabel");
    
    HashMap<String, TowerPropertyTable> towerMap = towerPropertyLookup.getMap();
    
    int count = 0;
    for (String towerName : towerMap.keySet()) {
      TowerSelectButton selectButton = new TowerSelectButton(towerName);
      
      int yMultiplier = count / TOWER_BUTTONS_PER_ROW;
      int xMultiplier = count % TOWER_BUTTONS_PER_ROW;
      
      float originalX = selectButton.imageButton.position.x;
      float originalY = selectButton.imageButton.position.y;
      PVector position = new PVector(originalX + (selectButton.imageButton.size.x + ROW_PADDING) * xMultiplier, originalY + (selectButton.imageButton.size.y + COLUMN_PADDING) * yMultiplier);
      selectButton.setPosition(position);
      
      this.buttons.add(selectButton);
      
      count++;
    }
  }
}

public class TowerSelectButton {
  private class TowerSelectImageButton extends ImageButton {
    private String towerName;
    
    public TowerSelectImageButton(JSONObject definition) {
      super(definition); 
    }
    
    public void setTower(String towerName) {
      this.towerName = towerName;
      
      PImage baseImage = towerPropertyLookup.getTowerProperties(towerName).getBaseSprite();
      this.setImage(baseImage);
    }
    
    public void onInput() {
      game.setCurrentTower(towerName);
    }
  }
  
  private String towerName;
  public TowerSelectImageButton imageButton;
  private TextLabel costLabel;
  
  public TowerSelectButton(String towerName) {
    this.towerName = towerName;
    this.costLabel = (TextLabel) guiManager.create("towerSelectCostLabel");
    this.imageButton = new TowerSelectImageButton(guiManager.getGuiDefinition("towerSelectButton"));
    guiManager.createCustom((GuiBase) this.imageButton);
    
    PVector costLabelPosition = new PVector(this.imageButton.position.x, this.imageButton.position.y + this.imageButton.size.y);
    this.costLabel.setPosition(costLabelPosition);
    
    this.imageButton.setTower(this.towerName);
    this.costLabel.setText("$" + towerPropertyLookup.getTowerProperties(towerName).getBaseCost());
  }
  
  public void setPosition(PVector position) {
    int deltaX = int(position.x - imageButton.position.x);
    int deltaY = int(position.y - imageButton.position.y);
    
    imageButton.setPosition(position);
    costLabel.translatePosition(deltaX, deltaY);
  }
}
