import java.util.*;

PImage INVALID_UPGRADE_IMAGE;

Game game;
BloonPropertyLookup bloonPropertyLookup;
BloonSpawner bloonSpawner;

TowerPropertyLookup towerPropertyLookup;

// GUI
FontManager fontManager;
GuiManager guiManager;

ArrayList<Tower>towers;

private PlayButton playButton;
private ReplayButton replayButton;
private PauseButton pauseButton;

void setup(){
  size(1200, 800);
  
  INVALID_UPGRADE_IMAGE = loadImage("images/upgradeIcons/invalidUpgrade.png");
  
  bloonPropertyLookup = new BloonPropertyLookup();
  bloonSpawner = new BloonSpawner();
  
  towerPropertyLookup = new TowerPropertyLookup();
  
  fontManager = new FontManager();
  guiManager = new GuiManager();
  
  
  
  playButton = new PlayButton(guiManager.getGuiDefinition("playButton"));
  guiManager.createCustom((GuiBase) playButton);
  playButton.setVisible(true);
  
  replayButton = new ReplayButton(guiManager.getGuiDefinition("replayButton"));
  guiManager.createCustom((GuiBase) replayButton);
  replayButton.setVisible(false);
  
  pauseButton = new PauseButton(guiManager.getGuiDefinition("pauseButton"));
  guiManager.createCustom((GuiBase) pauseButton);
    
  game = new Game(playButton, replayButton, pauseButton);
  /*
  JSONObject spawnInformation = new JSONObject();
  spawnInformation.setString("layerName", "Zebra");
  
  
  JSONObject modifiers = new JSONObject();
  //modifiers.setBoolean("camo", true);
  //modifiers.setBoolean("regrow", true);
  spawnInformation.setJSONObject("modifiers", modifiers);
  
  //bloonSpawner.spawn(spawnInformation);
  */
}

void draw(){
  background(255);
  game.render();
  if(game.isGameActive() && !game.isPaused()){
    
    game.update();
  }
  // Render UI after everything else to ensure it ends up on top
  guiManager.render();

}

void mouseMoved() {
  guiManager.mouseMoved();
}

void mousePressed(){
  boolean pressedButton = guiManager.mousePressed();
  
  // GUI sank input, so don't do anything else!
  if (pressedButton) {
    return;
  }
  
  game.mousePressed(mouseX, mouseY);
  
  
}

void keyPressed(){
  if (!game.isGameActive()) {
    return;
  }
  
  // Cheat menu keybind: c
  
  if (key == 'c') {
    game.cheatMenu.setVisible(!game.cheatMenu.isEnabled);
  }
}
