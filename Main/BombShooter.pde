public class BombShooter extends Tower{
  public BombShooter(int x, int y){
    super(x,y,50,30,10,5);
  }
  
  public void attack(ArrayList<Bloon> bloons){
    for (Bloon currentBloon : bloons){
      if (PVector.dist(new PVector(x,y), currentBloon.position) < radius){
        for (Bloon bloon : bloons){
          if (PVector.dist(new PVector(currentBloon.position.x, currentBloon.position.y), bloon.position) <30){
            bloon.damage(this.damage);
          }
        }
        break;
      }
    }
  }
  
  public void upgrade(int path){
  }
  
  public void draw(){
    fill(0,0,255);
    ellipse(x,y,25,25);
  }
  
  public int getCost(){
    return 0;
  }
}
