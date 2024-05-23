public class Bloon {
  private int layerId;
  private float layerHealth;
  private float speed;
  private PImage sprite;
  private BloonModifiersList modifiersList;
  
  private int positionId;
  
  public Bloon(String layerName) {
    this.modifiersList = new BloonModifiersList(this);
    
    this.positionId = 0;
  }
  
  public void damage(float count) {
    
  }
  
  public void move() {
    
  }
  
  public void handleLayerDeath() {
    
  }
  
}
