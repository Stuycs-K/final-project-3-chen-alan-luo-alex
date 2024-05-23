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
  
  public BloonModifier getModifierByName(String name) {
    for (BloonModifier modifier: modifiersList) {
      if (modifier.getModifierName().equals(name)) {
        return modifier;
      }
    }
    
    return null;
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
  
  public void addModifier(BloonModifier newModifier) {
     modifiersList.add(newModifier);
  }
  
  public void addModifierNoStack(BloonModifier newModifier) {
    BloonModifier existingModifier = getModifierByName(newModifier.getModifierName());
    if (existingModifier == null) {
      addModifier(newModifier); 
      return;
    }
    
    existingModifier.onStackAttempt(newModifier);
  }
}
