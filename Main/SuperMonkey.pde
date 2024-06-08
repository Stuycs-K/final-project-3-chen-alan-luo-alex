public class SuperMonkey extends Tower {
  public SuperMonkey(int x, int y) {
    super("SuperMonkey", x, y);
  }
  
  public ArrayList<Bloon> getTargetBloons(ArrayList<Bloon> bloons) {
    // Only do this for non Robo Monkey upgrades!
    if (this.upgrades.getCurrentLevel(1) < 3) {
      return super.getTargetBloons(bloons);
    }
    
    // Robo Monkey hits the first and the last target!!!
    ArrayList<Bloon> targets = new ArrayList<Bloon>();
    
    ArrayList<Bloon> targetBlacklist = new ArrayList<Bloon>();
    
    Bloon firstBloon = this.targetFilter.getFirst();
    
    // No bloon at all, so there shouldn't be an attack
    if (firstBloon == null) {
      return targets;
    }
    targetBlacklist.add(firstBloon);
    
    Bloon lastBloon = this.targetFilter.getLast(targetBlacklist);
    
    // No second bloon to target, so focus both attacks on the same bloon 
    if (lastBloon == null) {
      lastBloon = firstBloon;
    }
    
    targets.add(lastBloon);
    targets.add(firstBloon);
    
    return targets;
  }
}
