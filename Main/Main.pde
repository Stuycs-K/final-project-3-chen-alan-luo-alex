Game game;
BloonPropertyLookup bloonPropertyLookup;
BloonSpawner bloonSpawner;
GuiManager guiManager;
ArrayList<Tower>towers;



void setup(){
  size(1200, 800);
  
  bloonPropertyLookup = new BloonPropertyLookup();
  bloonSpawner = new BloonSpawner();
  guiManager = new GuiManager();
  
  game = new Game();
  game.startGame();
  
  JSONObject spawnInformation = new JSONObject();
  spawnInformation.setString("layerName", "MOAB");
  
  //spawnInformation.setInt("count", 5);
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
