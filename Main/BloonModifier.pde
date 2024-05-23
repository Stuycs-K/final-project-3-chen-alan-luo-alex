public class BloonModifier {
  private float duration;
  private String name;
  
  public BloonModifier(String name) {
    this.duration = -1; // Infinite duration
    this.name = name;
  }
  
  public BloonModifier(String name, float duration) {
    this.duration = duration; // Infinite duration
    this.name = name;
  }
  
  public void setDuration(float duration) {
    this.duration = duration;
  }
  
  public float getDuration() {
    return this.duration; 
  }
  
  public String getModifierName() {
    return this.name;
  }
  
  public void drawVisuals(Bloon bloon) {
    
  }
  
  public void onStep() {
    
  }
  
  public void onRemove() {
    
  }
  
  public void onApply() {
    
  }
}
