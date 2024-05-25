public class BloonModifier {
  private float duration;
  private String name;
  private JSONObject properties;
  
  public BloonModifier(String name) {
    this.duration = -1; // Infinite duration
    this.name = name;
  }
  
  public BloonModifier(String name, float duration) {
    this.duration = duration;
    this.name = name;
    this.properties = bloonPropertyLookup.getModifier(name);
  }
  
  public void setDuration(float duration) {
    this.duration = duration;
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
  
  public void drawVisuals(Bloon bloon) {
    
  }
  
  public void onStackAttempt(BloonModifier otherModifier) {
    
  }
  
  public void onStep() {
    
  }
  
  public void onRemove() {
    
  }
  
  public void onApply() {
    
  }
}
