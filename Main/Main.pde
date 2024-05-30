import java.util.*;

Game game;
BloonPropertyLookup bloonPropertyLookup;
BloonSpawner bloonSpawner;

// GUI
FontManager fontManager;
GuiManager guiManager;

ArrayList<Tower>towers;



void setup(){
  size(1200, 800);
  
  bloonPropertyLookup = new BloonPropertyLookup();
  bloonSpawner = new BloonSpawner();
  
  fontManager = new FontManager();
  guiManager = new GuiManager();
  
  game = new Game();
  game.startGame();
  
  JSONObject spawnInformation = new JSONObject();
  spawnInformation.setString("layerName", "MOAB");
  
  //spawnInformation.setInt("count", 5);
  bloonSpawner.spawn(spawnInformation);
  

  
}

void draw(){
  background(255);
  game.render();
  game.update();
  
  guiManager.render();

}


void mousePressed(){
  
  game.placeTower("DartMonkey", mouseX, mouseY);
  
  
}

void KeyPressed(){
}
