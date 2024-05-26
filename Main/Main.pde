Game game;
BloonPropertyLookup bloonPropertyLookup;
BloonSpawner bloonSpawner;

void setup(){
  size(1200, 800);
  
  bloonPropertyLookup = new BloonPropertyLookup();
  bloonSpawner = new BloonSpawner();
  
  game = new Game();
  game.startGame();
  
  JSONObject spawnInformation = new JSONObject();
  spawnInformation.setString("layerName", "Rainbow");
  //spawnInformation.setInt("count", 5);
  bloonSpawner.spawn(spawnInformation);
}

void draw(){
  background(255);
  game.render();
  game.update();

}

void mousePressed(){
  println("Mousse pressed at: " + mouseX + "," + mouseY);
  game.placeTower("DartMonkey", mouseX, mouseY);
  
  
}

void KeyPressed(){
}
