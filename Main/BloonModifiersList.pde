public class BloonModifiersList {
  private ArrayList<BloonModifier> modifiersList;
  private Bloon bloon;
  
  public BloonModifiersList(Bloon bloon) {
    this.bloon = bloon;
    this.modifiersList = new ArrayList<BloonModifier>();
  }
  
  public void applyModifierVisuals() {
    for (BloonModifier modifier: modifiersList) {
      modifier.drawVisuals(this.bloon);
    }
  }
  
  public ArrayList<BloonModifier> getModifiers() {
    return this.modifiersList;
  }
  
  public void stepModifiers() {
    for (BloonModifier modifier: modifiersList) {
      modifier.onStep();
    }
  }
  
  private boolean hasModifier(String name) {
    for (BloonModifier modifier: modifiersList) {
      if (modifier.getModifierName().equals(name)) {
        return true;
      }
    }
    
    return false;
  }
  
  public void addModifier(String name) {
    BloonModifier newModifier = new BloonModifier(name);
    modifiersList.add(newModifier);
  }
  
}
