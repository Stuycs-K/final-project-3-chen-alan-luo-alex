public class BloonModifiersList {
  private ArrayList<BloonModifier> modifiersList;
  private Bloon bloon;
  
  public BloonModifiersList(Bloon bloon) {
    this.bloon = bloon;
    this.modifiersList = new ArrayList<BloonModifier>();
    
    // Set default properties
    BloonPropertyTable properties = bloon.getProperties();
    JSONObject modifiers = properties.getModifierArray();
    if (modifiers == null) {
      return;
    }
    
    String[] keyNames = new String[modifiers.size()];
    keyNames = (String[]) modifiers.keys().toArray(keyNames);
    for (String keyName : keyNames) {
      
      try { // If our entry is "true," apply it with no extra information
        modifiers.getBoolean(keyName);
        addModifier(keyName);
      } catch (Exception exception) {
        
      }
    }
  }
  
  public void applyModifierVisuals() {
    for (BloonModifier modifier: modifiersList) {
      modifier.drawVisuals(this.bloon);
    }
  }
  
  public ArrayList<BloonModifier> getModifiers() {
    return this.modifiersList;
  }
  
  public ArrayList<BloonModifier> getHeritableModifiers() {
    ArrayList<BloonModifier> heritableModifiers = new ArrayList<BloonModifier>();
    
    for (BloonModifier modifier : modifiersList) {
      if (modifier.isHeritable()) {
        heritableModifiers.add(modifier); 
      }
    }
    return heritableModifiers;
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
  
  public boolean hasModifier(String name) {
    for (BloonModifier modifier: modifiersList) {
      if (modifier.getModifierName().equals(name)) {
        return true;
      }
    }
    
    return false;
  }
  
  public void copyModifiers(ArrayList<BloonModifier> modifiers) {
    for (BloonModifier modifier : modifiers) {
      addModifier(modifier.clone());
    }
  }
  
  public void addModifiers(JSONObject modifiers) {
    
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
