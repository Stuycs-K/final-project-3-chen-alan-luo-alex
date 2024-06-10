import java.util.Map;

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
  
  // Calculates final damage based on the damage properties
  // A value of -1 indicates immunity to the damage (e.g. sharp projectile hitting lead bloon)
  public float getDamage(float baseDamage, DamageProperties damageProperties) {
    float finalDamage = baseDamage;
    
    // Sharp vs. lead
    if (hasModifier("sharpImmunity") && !damageProperties.popLead) {
      return -1;
    }
    
    // Explosions vs. black
    if (hasModifier("blastImmunity") && !damageProperties.popBlack) {
      return -1;
    }
    
    if (hasModifier("frozen") && !damageProperties.popFrozen) {
      return -1;
    }
    
    if (hasModifier("isCeramic")) {
      finalDamage += damageProperties.extraDamageToCeramics;
    }
    
    if (hasModifier("isMoab")) {
      finalDamage += damageProperties.extraDamageToMoabs;
    }
    
    return finalDamage;
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
    
    ArrayList<String> modifiersToRemove = new ArrayList<String>();
    for (String modifierName : modifierMap.keySet()) {
      BloonModifier modifier = modifierMap.get(modifierName);
      
      if (modifier.shouldRemove()) {
        modifiersToRemove.add(modifierName);
        modifier.onRemove();
        continue;
      }
      
      modifier.onStep();
    }
    
    for (String modifierName : modifiersToRemove) {
      modifierMap.remove(modifierName); 
    }
  }
  
  public boolean hasModifier(String name) {
    return (modifierMap.get(name) != null);
  }
  
  public void copyModifiers(ArrayList<BloonModifier> modifiers) {
    for (BloonModifier modifier : modifiers) {
      BloonModifier cloned = modifier.clone();
      addModifier(cloned);
    }
  }
  
  public void addModifiers(JSONObject modifiers) {
    if (modifiers == null) {
      return;
    }
    
    Set<String> keySet = modifiers.keys();
    for (String keyName : keySet) {
      try { // If our entry is "true," apply it with no extra information
        if (modifiers.getBoolean(keyName) == true) {
          addModifier(keyName);
        }

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
     modifierMap.put(newModifier.getModifierName(), newModifier);
  }
  
  public void addModifierWithStack(BloonModifier newModifier) {
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
  private float timeRemaining;
  private String name;
  private Bloon bloon;
  
  public boolean shouldRemove;
  
  private JSONObject baseProperties;
  private JSONObject customProperties;
  
  public BloonModifier(String name, float duration) {
    this.duration = duration;
    this.timeRemaining = duration;
    this.name = name;
    this.baseProperties = bloonPropertyLookup.getModifier(name);
    this.shouldRemove = false;
  }
  
  public BloonModifier(String name) {
    this(name, -1);
  }
  
  public void setCustomProperties(JSONObject customProperties) {
    this.customProperties = customProperties; 
  }
  
  public boolean shouldRemove() {
    return shouldRemove;
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
    this.timeRemaining = duration;
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
  
  public void onStackAttempt(BloonModifier otherModifier) {
    return;
  }
  
  public void setTimeRemaining(float time) {
    this.timeRemaining = time;
  }
  
  public void onStep() {
    if (duration <= -1) {
      return;
    }
    
    float deductTime = 1 / frameRate;
    this.timeRemaining -= deductTime;
    
    if (this.timeRemaining <= 0) {
      this.shouldRemove = true;
    }
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
    
    ArrayList<Integer> parentNames = bloon.parentHistory;
    
    if (properties.getLayerName().equals(getCustomProperties().getString("maxLayerName"))) {
      parentNames.clear();
      return;
    }
    
    if (cooldown >= regrowRate) {
      bloon.setLayer(parentNames.get(parentNames.size() - 1));
      parentNames.remove(parentNames.size() - 1);
      
      cooldown = 0;
    } else {
      cooldown++;
    }
  }
}

public class Stun extends BloonModifier {
  public Stun() {
    super("stun");
  }
  
  public Stun clone() {
    Stun newStun = new Stun();
    newStun.setDuration(getDuration());
    return newStun; 
  }
  
  public void onStep() {
    // DON'T stun bloons that are being blown back. Stun them when they're finished getting blown
    if (getBloon().getModifiersList().hasModifier("blowback")) {
      return;
    }
    
    super.onStep();
    
    getBloon().setSpeedMultiplier(0);
  }
  
  public void onRemove() {
    getBloon().setSpeedMultiplier(1);
  }
  
  public void onStackAttempt(Stun otherModifier) {
    setTimeRemaining(otherModifier.getDuration());
  }
}

public class Blowback extends BloonModifier {
  private float unitsBlownback;
  private PVector goalPosition;
  
  private PVector lastDirection;
  
  public Blowback(float unitsBlownback, PVector goalPosition) {
    super("blowback");
    
    this.unitsBlownback = unitsBlownback;
    
    this.goalPosition = goalPosition;
  }
  
  public Blowback(float unitsBlownback) {
    super("blowback");
    
    this.unitsBlownback = unitsBlownback;
  }
  
  public Blowback() {
    this(100); 
  }
  
  public void onStep() {
    Bloon bloon = getBloon();
    if (goalPosition == null) {
      return;
    }
    
    float distanceToGoal = PVector.dist(bloon.position, this.goalPosition);
    
    if (distanceToGoal <= bloon.speed / frameRate) {

      this.shouldRemove = true;
      return;
    }
    
    // Stop the bloon from moving normally!
    bloon.setSpeedMultiplier(0);
    
    // We're going to use the bloon's speed value
    PVector direction = PVector.sub(this.goalPosition, bloon.position).normalize();
    
    if (lastDirection != null) {
      // This means we're snapping back and forth between the goal position
      if (direction.dot(lastDirection) < 0.1) {
        this.shouldRemove = true;
        return;
      }
    }
    lastDirection = direction;
   
    direction.mult(bloon.speed / frameRate);
    
    bloon.position.add(direction);
  }
  
  public void setBloon(Bloon bloon) {
    super.setBloon(bloon);

    if (this.goalPosition != null) {
      return;
    }
    
    // Get the position unitsBlownback units back
    PVector finalPosition = bloon.position.copy();
    float totalDistanceToMove = unitsBlownback;
    
    while (true) {
      MapSegment segment = game.getMap().getMapSegment(bloon.positionId);
      
      PVector direction = PVector.sub(segment.getStart(), segment.getEnd()).normalize();
      float distanceToStart = PVector.dist(finalPosition, segment.getStart());
      
      // The final position is going to be in the bounds of the current segment
      if (totalDistanceToMove <= distanceToStart) {
        finalPosition = PVector.add(finalPosition, direction.mult(totalDistanceToMove));
        break;
      } else {
        finalPosition = segment.getStart().copy();
        totalDistanceToMove -= distanceToStart;
        
        int nextPositionId = bloon.positionId - 1;
        
        // Limit bloons to the start of the map
        if (nextPositionId < 0) {
          finalPosition = game.getMap().getMapSegment(0).getStart();
          bloon.positionId = 0;
          break;
        }
        
        bloon.positionId -= 1;
      }
    }
    
    this.goalPosition = finalPosition.copy(); 
  }
  
  public void onRemove() {
    Bloon bloon = getBloon();
    bloon.setSpeedMultiplier(1);
  }
  
  public Blowback clone() {
    Blowback newEffect = new Blowback(this.unitsBlownback, this.goalPosition);
    return newEffect;
  }
}
