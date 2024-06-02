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
      MapSegment currentMapSegment = game.getMap().getMapSegment(bloon.getPositionId());

      if (currentMapSegment == null) {
        return;
      }
      
      PVector target = currentMapSegment.getEnd();
      PVector currentPosition = bloon.getPosition();
      float angle = atan2(target.y - currentPosition.y, target.x - currentPosition.x) - PI / 2;
      
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

public class BloonModifier {
  private float duration;
  private String name;
  private Bloon bloon;
  
  private JSONObject baseProperties;
  private JSONObject customProperties;
  
  public BloonModifier(String name, float duration) {
    this.duration = duration;
    this.name = name;
    this.baseProperties = bloonPropertyLookup.getModifier(name);
  }
  
  public BloonModifier(String name) {
    this(name, -1);
  }
  
  public void setCustomProperties(JSONObject customProperties) {
    this.customProperties = customProperties; 
  }
  
  public JSONObject getCustomProperties() {
    return customProperties;
  }
  
  // Must call this after constructor!
  public void setBloon(Bloon bloon) {
    this.bloon = bloon;
  }
  
  public Bloon getBloon() {
    return bloon;
  }
  
  public String getName() {
    return name;
  }
  
  public void setDuration(float duration) {
    this.duration = duration;
  }
  
  public BloonModifier clone() {
    BloonModifier copy = new BloonModifier(name, duration);
    
    if (customProperties != null) {
      copy.setCustomProperties(customProperties);
    }

    return copy;
  }
  
  public boolean isHeritable() {
    return baseProperties.getBoolean("heritable"); 
  }
  
  public float getDuration() {
    return this.duration; 
  }
  
  public String getModifierName() {
    return this.name;
  }
  
  public void drawVisuals() {
    return;
  }
  
  public void onStackAttempt(BloonModifier otherModifier) {
    return;
  }
  
  public void onStep() {
    drawVisuals();
  }
  
  public void onRemove() {
    return;
  }
  
  public void onApply() {
    return;
  }
}


public class Camo extends BloonModifier {
  public Camo() {
    super("camo");
  }
  
  public Camo clone() {
    return new Camo(); 
  }
}

public class Regrow extends BloonModifier {
  private int regrowRate; // 1 layer per this number of ticks
  private int cooldown;
  
  public Regrow(String maxLayerName) {
    super("regrow");
    
    JSONObject properties = new JSONObject();
    properties.setString("maxLayerName", maxLayerName);
    
    super.setCustomProperties(properties);
    
    this.regrowRate = int(2.5 * frameRate); // 2.5 seconds by default
    this.cooldown = 0;
  }
  
  public Regrow(String maxLayerName, int regrowRate) {
    this(maxLayerName);
    this.regrowRate = regrowRate;
  }
  
  public Regrow clone() {
    Regrow newModifier = new Regrow(getCustomProperties().getString("maxLayerName"));
    
    return newModifier;
  }
  
  public int getRegrowRate() {
    return regrowRate; 
  }
  
  public void onStackAttempt(Regrow otherModifier) {
    int otherRegrowRate = otherModifier.getRegrowRate();
    if (otherRegrowRate < regrowRate) {
      regrowRate = otherRegrowRate;
    }
  }
  
  public void onStep() {
    Bloon bloon = getBloon();
    BloonPropertyTable properties = bloon.getProperties();
    
    if (properties.getLayerName().equals(getCustomProperties().getString("maxLayerName"))) {
      return;
    }
    
    if (cooldown >= regrowRate) {
      bloon.setLayer(properties.getLayerId() + 1);
      cooldown = 0;
    } else {
      cooldown++;
    }
  }
}
