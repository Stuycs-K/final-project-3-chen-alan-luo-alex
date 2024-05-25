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
  
  test = new Bloon("Black");
  game.bloons.add(test);
}

void draw(){
  background(255);
  game.render();
  game.update();

}

void mousePressed(){
  
}

void KeyPressed(){
}
