public class SuperMonkey extends Tower {
  public SuperMonkey(int x, int y) {
    super("SuperMonkey", x, y);
  }
  
  public ArrayList<Bloon> getTargetBloons(ArrayList<Bloon> bloons) {
    // Only do this for non Robo Monkey upgrades!
    if (this.upgrades.getCurrentLevel(1) < 3) {
      return super.getTargetBloons(bloons);
    }
    
    ArrayList<Bloon> targets = new ArrayList<Bloon>();
    
    return targets;
  }
}

public class MultiTargetAction {
  
}
