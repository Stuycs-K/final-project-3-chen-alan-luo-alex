public class BloonModifier {
  private float duration;
  private String name;
  private Bloon bloon;
  private JSONObject properties;
  
  public BloonModifier(String name, float duration) {
    this.duration = duration;
    this.name = name;
    this.properties = bloonPropertyLookup.getModifier(name);
  }
  
  public BloonModifier(String name) {
    this(name, -1);
  }
  
  // Must call this after constructor!
  public void setBloon(Bloon bloon) {
    this.bloon = bloon;
  }
  
  public void setDuration(float duration) {
    this.duration = duration;
  }
  
  public BloonModifier clone() {
    BloonModifier copy = new BloonModifier(name, duration);
    return copy;
  }
  
  public boolean isHeritable() {
    return properties.getBoolean("heritable"); 
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
    return;
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
  
  public void drawVisuals(Bloon bloon) {
    
  }
}

public class Regrow extends BloonModifier {
  private float regrowRate;
  private int maxLayerId;
  
  public Regrow() {
    super("regrow");
  }
  
  public void drawVisuals() {
    
  }
  
  public float getRegrowRate() {
    return regrowRate; 
  }
  
  public void onStackAttempt(Regrow otherModifier) {
    float otherRegrowRate = otherModifier.getRegrowRate();
    if (otherRegrowRate < regrowRate) {
      regrowRate = otherRegrowRate;
    }
  }
  
  public void onStep() {
    
  }
}
