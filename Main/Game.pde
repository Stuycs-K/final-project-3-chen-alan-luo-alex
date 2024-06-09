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
  private TextButton pauseButton;
  private PlayButton playButton;
  private Frame startScreenBackground;
  private Frame endScreenBackground;
  private ReplayButton replayButton;
  private SpeedButton speedButton;
  private boolean isSpeedDoubled;
  
  
  public CheatMenu cheatMenu;
  private UpgradePanel upgradePanel;
  private TowerSelectionPanel towerSelectionPanel;
  
  private boolean isPaused;

  
  
  public Game(PlayButton playButton, ReplayButton replayButton, PauseButton pauseButton, SpeedButton speedButton) {
    this.playButton = playButton;
    this.replayButton = replayButton;
    this.speedButton = speedButton;
        
    PImage mapImage = loadImage("images/map.png");
    ArrayList<PVector> waypoints = new ArrayList<PVector>();
    waypoints.add(new PVector(0, 200));
    waypoints.add(new PVector(190, 200));
    waypoints.add(new PVector(190, 320));
    waypoints.add(new PVector(95, 320));
    waypoints.add(new PVector(95, 700));
    waypoints.add(new PVector(190,700));
    waypoints.add(new PVector(190, 435));
    waypoints.add(new PVector(305, 435));
    waypoints.add(new PVector(305, 505));
    waypoints.add(new PVector(385,505)); 
    waypoints.add(new PVector(385, 335));
    waypoints.add(new PVector(475, 335));
    waypoints.add(new PVector(475, 595));
    waypoints.add(new PVector(345, 595));
    waypoints.add(new PVector(345, 705)); 
    waypoints.add(new PVector(565, 705));
    waypoints.add(new PVector(565, 555));
    waypoints.add(new PVector(645, 555));
    waypoints.add(new PVector(645, 605));
    waypoints.add(new PVector(735, 605));
    waypoints.add(new PVector(735, 465));
    waypoints.add(new PVector(625, 465));
    waypoints.add(new PVector(625, 330));
    waypoints.add(new PVector(795, 330));
    waypoints.add(new PVector(795, 215));
    waypoints.add(new PVector(565, 215));
    waypoints.add(new PVector(565, 105));
    waypoints.add(new PVector(955, 105));
    waypoints.add(new PVector(955, 742));
    //waypoints.add(new PVector(
   
  
    map = new Map(waypoints, 9, mapImage);
    towers = new ArrayList<>();
    bloons = new ArrayList<>();
    projectiles = new ArrayList<Projectile>();
    
    currencyPerPopMultiplier = 1;
    
    healthManager = new HealthManager(200);
    currencyManager = new CurrencyManager();
    
    waveManager = new WaveManager();
    
    showTowerOptions = false;
    setupGui();
    
  }
  public boolean isPaused(){
    return isPaused;
  }
  
  public boolean isGameActive() {
    return gameActive;
  }
  public Map getMap() {
    return map;
  }
  
  public boolean isSpeedDoubled(){
    return isSpeedDoubled;
  }
  
  public void setSpeedDoubled(boolean isSpeedDoubled){
    this.isSpeedDoubled = isSpeedDoubled;
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
  
  
  public void hideStartScreen(){
    startScreenBackground.setVisible(false);
    playButton.setVisible(false);
  }
  
  public void showEndScreen(){
    endScreenBackground.setVisible(true);
    replayButton.setVisible(true);
  }
  
  public void hideEndScreen(){
    endScreenBackground.setVisible(false);
    replayButton.setVisible(false);
  }
  
  public void resetGame(){
    towers.clear();
    bloons.clear();
    projectiles.clear();
    healthManager = new HealthManager(200);
    currencyManager = new CurrencyManager();
    waveManager = new WaveManager();
    gameActive = false;
    isPaused = false;
    showTowerOptions = false;
    selectedTower = null;
    currentTowerType = null;
    placementLabel.setVisible(false);
    hideEndScreen();
    cheatMenu.setVisible(false);
    setupGui();
  }
  

  
  public CurrencyManager getCurrencyManager() {
    return currencyManager;
  }
  
  public float getCurrencyPerPopMultiplier() {
    return currencyPerPopMultiplier;
  }

  public void startGame(){
    gameActive = true;
    
    waveManager.setWave(0);
    waveManager.startNextWave();
    currencyManager.setCurrency(650);
    
    hideStartScreen();
  }
  
  public void togglePause(boolean isPaused){
    this.isPaused = isPaused;
  }
  
   public void update(){
     if(!gameActive || isPaused){
       return;
     }
     
     performUpdate();
     
     if(isSpeedDoubled){
       performUpdate();
     }
   }
   private void performUpdate() {
    if (healthManager.didLose()) {
      gameActive = false;
      showEndScreen();
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
    
    startScreenBackground = (Frame) guiManager.create("startScreenBackground");
    
    endScreenBackground = (Frame) guiManager.create("endScreenBackground");
    endScreenBackground.setVisible(false);
    

    upgradePanel = new UpgradePanel();
    upgradePanel.setVisible(false);
    
    towerSelectionPanel = new TowerSelectionPanel();
    
    cheatMenu = new CheatMenu();
    cheatMenu.setVisible(false);

    placementLabel = (TextLabel) guiManager.create("placementLabel");
    
    
   }
  
  public void placeTower(String towerName, int x, int y){
    PVector position = new PVector(x, y);
    
    // Do we even have a tower type selected?
    if (currentTowerType == null) {
      return;
    }
    
    // Would we place it on the path?
    if (map.isCircleOnPath(position, Tower.TOWER_FOOTPRINT_SIZE)) {
      return;
    }
    
    // Would it intersect with other towers?
    for (Tower tower : towers) {
      PVector towerPosition = new PVector(tower.x, tower.y);
      
      if (circleIntersectsCircle(position, Tower.TOWER_FOOTPRINT_SIZE, towerPosition, tower.footprint)) {
        return;
      }
    }
      
    int startingCost = towerPropertyLookup.getTowerProperties(towerName).getBaseCost();
    if(currencyManager.getCurrency() >= startingCost){
      currencyManager.removeCurrency(startingCost);
    }
    else {
      return;
    }
  
    Tower newTower = null;
    switch (towerName) {
      case "DartMonkey":
        newTower = new DartMonkey(x, y);
        break;
      case "BombShooter":
        newTower = new BombShooter(x, y);
        break;
      case "SuperMonkey":
        newTower = new SuperMonkey(x, y);
        break;
      case "NinjaMonkey":
        newTower = new NinjaMonkey(x, y);
        break;
      case "SniperMonkey":
        newTower = new SniperMonkey(x,y);
        break;
    }

   if(newTower != null){
     towers.add(newTower);
     selectedTower = null;
     currentTowerType = null;
     placementLabel.setVisible(false);
   }
      
    
  }
  
  public void showTowerRange(Tower tower) {
    stroke(255, 255, 255);
    noFill();
    circle(tower.x, tower.y, tower.range * 2);
  }
 
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
        showTowerRange(tower);
      }
    }
    
    for (Bloon bloon : bloons) {
       bloon.render(); 
    }
    
    for (Projectile projectile : projectiles) {
      projectile.drawProjectile();
    }
    
    if (!gameActive) {
      startScreenBackground.render();
      playButton.render();
    }
  }
  
  private void drawHighlightCircle(int x, int y){
    stroke(255,204,0);
    noFill();
    circle(x, y, 75);
  }
  
  public void mousePressed(int mx, int my) {
    
   if (currentTowerType != null && !guiManager.mousePressed()) {
      placeTower(currentTowerType, mx, my);
      return;
   }
    
    PVector mousePosition = new PVector(mouseX, mouseY);
    for (Tower tower : towers) {
      if (pointInCircle(new PVector(tower.x, tower.y), tower.footprint, mousePosition)) {
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
    towerNameLabel.setVisible(state);
    
    for (UpgradeButton button : upgradeButtons) {
      button.setVisible(state);
    }
  }
  
  public void onTowerSelect(Tower tower) {
    setVisible(true);
    displayTowerInformation(tower);
    
    sellButton.setText("Sell: " + int(tower.getSellPrice()));
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
      int startingCost = towerPropertyLookup.getTowerProperties(towerName).getBaseCost();
      if(game.currencyManager.getCurrency() >= startingCost){
      }
      else if(game.currencyManager.getCurrency() < startingCost){
        return;
       }
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

public class PlayButton extends TextButton{
  public PlayButton(JSONObject defintion){
    super(defintion);
  }
  public void onInput(){
    game.startGame();
  }
}

public class ReplayButton extends TextButton{
  public ReplayButton(JSONObject defintion){
    super(defintion);
  }
  
  public void onInput(){
    game.resetGame();
    game.startGame();
    
  }
}

public class PauseButton extends TextButton{
  private boolean isPaused;
  
  public PauseButton (JSONObject defintion){
    super(defintion);
    this.isPaused = false;
 }
 
 public void onInput(){
   isPaused = !isPaused;
   game.togglePause(isPaused);
   updateText();
 }
 
 private void updateText(){
   if(isPaused){
     setText("Unpause");
     
 } else{
   setText("Pause");
   }
  }
}

public class SpeedButton extends TextButton{
  private boolean isSpeedDoubled;
  
  public SpeedButton(JSONObject defintion){
    super(defintion);
    this.isSpeedDoubled = false;
    updateText();
  }
  
  public void onInput(){
    isSpeedDoubled = !isSpeedDoubled;
    game.setSpeedDoubled(isSpeedDoubled);
    updateText();
  }
  
  public void updateText(){
    if(isSpeedDoubled){
      setText("Normal Speed");
    }else{
      setText("Double Speed");
  }
}
}
