public class BloonModifier {
  private float duration;
  private String name;
  private JSONObject properties;
  
  public BloonModifier(String name, float duration) {
    this.duration = duration;
    this.name = name;
    this.properties = bloonPropertyLookup.getModifier(name);
  }
  
  public BloonModifier(String name) {
    this(name, -1);
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
