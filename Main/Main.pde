Game game;
BloonPropertyLookup bloonPropertyLookup;

void setup(){
  size(800, 600);
  
  bloonPropertyLookup = new BloonPropertyLookup();
  
  game = new Game();
  game.startGame();
}

void draw(){
  background(255);
  game.update();
  game.render();
  
  
}

void mousePressed(){

}

void KeyPressed(){
}
