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
  bloonSpawner.spawn(spawnInformation);
  
  //temp setup below
  //text("UpdateTower", 100, 100);
  //fill(0,255,0);
  //text("SellTower", 100, 100);
  //fill(255,0,0);
  
  
}

void draw(){
  background(255);
  game.render();
  game.update();
  
  // Render UI after everything else to ensure it ends up on top
  guiManager.render();

}

//void drawTowerOptions(int x, int y, String name){
//  if(mousePressed
//  text(name,x,y);
  
//}

void mousePressed(){
  
  game.placeTower("DartMonkey", mouseX, mouseY);
  
  
}

void KeyPressed(){
}
