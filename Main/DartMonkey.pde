public class DartMonkey extends Tower{
  public DartMonkey (int x, int y){
    super(x,y,40,20,5,10);
  }
  
  public void attack(ArrayList<Bloon> bloons){
    for (Bloon bloon: bloons){
      if(PVector.dist(new PVector(x,y), new PVector(bloon.getX(), bloon.getY())) < radius){
        bloon.damage(this.damage);
        break;
      }
    }
  }
  
  public void upgrade(){
  }
  
  public void draw(){
    fill(255);
    ellipse(x,y,20,20);
  }
}
