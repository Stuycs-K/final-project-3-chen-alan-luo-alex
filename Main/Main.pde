Game game;
BloonPropertyLookup bloonPropertyLookup;

Bloon test;

void setup(){
  size(800, 600);
  
  bloonPropertyLookup = new BloonPropertyLookup();
  
  game = new Game();
  game.startGame();
  
  test = new Bloon("Blue");
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
