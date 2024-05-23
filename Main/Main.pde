Game game;

void setup(){
  size(800, 600);
  game = new Game();
  game.startGame();
}

void draw(){
  background(255);
  game.update();
  game.draw();
}

void mousePressed(){

}

void KeyPressed(){
}
