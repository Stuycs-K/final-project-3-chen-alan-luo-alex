public class DartMonkey extends Tower{
  
  public DartMonkey (int x, int y){
    super(x,y,40,20,5,10);
  }
  
  public void attack(ArrayList<Bloon> bloon){
    for (Bloon currentBloon: bloon){
      if(TowerTargetFilter.canAttack(bloon)){
        if(PVector.dist(new PVector(x,y), new PVector(currentBloon.x, currentBloon.y)) < radius){
          currentBloon.damage(this.damage);
          break;
        }
      }
    }
  }
  
  public void upgrade(int path){
    if (path == 1){
      String[] upgradesPathOne = new String []{"Default","Long Range Darts", "Enchanced Eyesight","Spike-O-Pult","Juggernaut"};
    }
    if(path == 2){
      String[] upgradePathTwo = new String[]{"Sharp Shots","Razor Sharp Shots","Triple Darts","Super Monkey Fan Club"};
    }
  }
  
  public void draw(){
    fill(255);
    ellipse(x,y,20,20);
  }
}
