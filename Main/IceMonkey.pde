public class IceMonkey extends Tower{
  public IceMonkey(int x, int y){
    super(x,y,60,40,2,8);
  }
  public void attack(ArrayList<Bloon> bloons){
    for(Bloon currentBloon : bloons){
      if(PVector.dist(new PVector(x,y), currentBloon.position) < radius){
        //currentBloon.freeze(10);
        break;
      }
    }
  }
  public void upgrade(int path){
    if (path == 1){
      String[] upgradesPathOne = new String []{"Permafrost","Cold Snap","Ice Shards","Embrittlement","Super Brittle"};
      for (int i = 0; i< upgradesPathOne.length; i++){
        //currentUpgrade = upgradesPathOne[upGradeLevel-1];
        //if (currentUpgrade.equals("Permafrost")){
          
        //}
        //if(currentUpg
      }
    }
    if(path == 2){
      String[] upgradePathTwo = new String[]{"Enhanced Freeze","Deep Freeze","Artic Wind","Snowstorm","Absolute Zero"};
    }
  }
  
  public void draw(){
    fill(0,255,255);
    ellipse(x,y,20,20);
  }
  
  public int getCost(){
    return 0;
  }
}
