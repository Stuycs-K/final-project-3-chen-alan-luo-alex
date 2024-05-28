public class IceMonkey extends Tower{
  public IceMonkey(int x, int y){
    super(x,y,60,40,2,8,20);
  }
  public void attack(ArrayList<Bloon> bloon){
    super.attack(bloon);
   }
  public void upgrade(int path){
  }
  
  public void draw(){
    fill(0,255,255);
    ellipse(x,y,20,20);
  }
  
  public int getCost(){
    return 0;
  }
}
