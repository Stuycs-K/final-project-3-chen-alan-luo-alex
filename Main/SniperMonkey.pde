public class SniperMonkey extends Tower {
  public SniperMonkey(int x, int y){
    super("SniperMonkey",x,y);
  }
  
  public void step(ArrayList<Bloon> bloons){
    ArrayList<Bloon> targetBloons = getTargetBloons(bloons);
    
    for(TowerAction action : actionMap.values()){
      if(action == null){
        continue;
      }
      if(!action.checkCooldown()){
        continue;
      }
      if(!action.shouldPerformAction(targetBloons)){
        continue;
    }
      action.performAction(this,targetBloons, bloons);
  }
  

}
  
  public ArrayList<Bloon> getTargetBloons(ArrayList<Bloon> bloons){
    return super.getTargetBloons(bloons);
  }
}
