Game game;
BloonPropertyLookup bloonPropertyLookup;
BloonSpawner bloonSpawner;

Bloon test;

void setup(){
  size(1200, 800);
  
  bloonPropertyLookup = new BloonPropertyLookup();
  bloonSpawner = new BloonSpawner();
  
  game = new Game();
  game.startGame();
  
  test = new Bloon("Blue");
  game.bloons.add(test);
}

void draw(){
  background(255);
  game.update();
  game.render();
  
  test.render();
}

void mousePressed(){
  
}

void KeyPressed(){
}
