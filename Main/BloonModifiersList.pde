public class BloonModifiersList {
  private HashMap<String, BloonModifier> modifierMap;
  private Bloon bloon;
  
  public BloonModifiersList(Bloon bloon) {
    this.bloon = bloon;

    this.modifierMap = new HashMap<String, BloonModifier>();
    
    // Set default properties
    BloonPropertyTable properties = bloon.getProperties();
    JSONObject modifiers = properties.getModifierArray();
    addModifiers(modifiers);
  }
  
  public void setSprite() {
    if (hasModifier("isMoab")) {
      PVector moveDirection = bloon.getMoveDirection();
      
      PVector base = new PVector(0, -1, 0);
      float angle = PVector.angleBetween(base, moveDirection);
      
      bloon.setSpriteRotation(angle);
      return;
    }
    
    String spriteName = "";
    if (hasModifier("camo")) {
      spriteName += "camo";
    }
    
    if (hasModifier("regrow")) {
      if (spriteName.length() == 0) {
        spriteName += "regrow";
      } else {
        spriteName += "Regrow";
      }
    }
    
    PImage sprite = bloon.getProperties().getSpriteVariant(spriteName);
    if (sprite == null) {
      return;
    }
    
    bloon.setSprite(sprite);
  }
  
  public HashMap<String, BloonModifier> getModifiers() {
    return this.modifierMap;
  }
  
  public ArrayList<BloonModifier> getHeritableModifiers() {
    ArrayList<BloonModifier> heritableModifiers = new ArrayList<BloonModifier>();
    
    for (BloonModifier modifier : modifierMap.values()) {
      if (modifier.isHeritable()) {
        heritableModifiers.add(modifier); 
      }
    }
    return heritableModifiers;
  }
  
  public BloonModifier getModifierByName(String name) {
    return modifierMap.get(name);
  }
  
  public void stepModifiers() {
    setSprite();
    
    for (BloonModifier modifier : modifierMap.values()) {
      modifier.onStep();
    }
  }
  
  public boolean hasModifier(String name) {
    return (modifierMap.get(name) != null);
  }
  
  public void copyModifiers(ArrayList<BloonModifier> modifiers) {
    for (BloonModifier modifier : modifiers) {
      addModifier(modifier.clone());
    }
  }
  
  public void addModifiers(JSONObject modifiers) {
    if (modifiers == null) {
      return;
    }
    
    Set<String> keySet = modifiers.keys();
    for (String keyName : keySet) {
      try { // If our entry is "true," apply it with no extra information
        modifiers.getBoolean(keyName);
        addModifier(keyName);
      } catch (Exception exception) {
        
      }
    }
  }
  
  public void addModifier(String name) {
    BloonModifier newModifier;
    switch (name) {
      case "regrow":
        newModifier = new Regrow(bloon.getProperties().getLayerName());
        break;
      case "camo":
        newModifier = new Camo();
        break;
      default:
        newModifier = new BloonModifier(name);
    }

    addModifier(newModifier);
  }
  
  public void addModifier(BloonModifier newModifier) {
     newModifier.setBloon(bloon);
     modifierMap.put(newModifier.getName(), newModifier);
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
