public class IceMonkey extends Tower{
  public IceMonkey(int x, int y){
    super(x,y,60,40,2,8);
  }
  public void attack(){
    
  }
  public void upgrade(int path){
    if (path == 1){
      String[] upgradesPathOne = new String []{"Default","Long Range Darts", "Enchanced Eyesight","Spike-O-Pult","Juggernaut"};
    }
    if(path == 2){
      String[] upgradePathTwo = new String[]{"Sharp Shots","Razor Sharp Shots","Triple Darts","Super Monkey Fan Club"};
    }
  }
}
