import java.util.*;

Game game;
BloonPropertyLookup bloonPropertyLookup;
BloonSpawner bloonSpawner;

TowerPropertyLookup towerPropertyLookup;

// GUI
FontManager fontManager;
GuiManager guiManager;

ArrayList<Tower>towers;



void setup(){
  size(1200, 800);
  
  bloonPropertyLookup = new BloonPropertyLookup();
  bloonSpawner = new BloonSpawner();
  
  towerPropertyLookup = new TowerPropertyLookup();
  
  fontManager = new FontManager();
  guiManager = new GuiManager();
  
  game = new Game();
  game.startGame();
  /*
  JSONObject spawnInformation = new JSONObject();
  spawnInformation.setString("layerName", "MOAB");
  bloonSpawner.spawn(spawnInformation);
  */
  

  
}

void draw(){
  background(255);
  game.render();
  game.update();
  
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

void KeyPressed(){
}
