public class Bloon {
  private int layerId;
  private float layerHealth;
  private float speed;
  private PImage sprite;
  private BloonModifiersList modifiersList;
  
  private int positionId;
  private PVector position;
  
  public Bloon(String layerName) {
    this.modifiersList = new BloonModifiersList(this);
    
    BloonPropertyTable properties = bloonPropertyLookup.getProperties(layerName);
    this.sprite = properties.getSprite();
    
    // Set the bloon's position to the start
    this.positionId = 0;
    this.position = game.getMap().getPositionOfId(0);
  }
  
  public Bloon(String layerName, PVector position) {
    Bloon(layerName);
    this.position = position;
  }
  
  public void render() {
     
  }
  
  public void damage(float count) {
    
  }
  
  public void move() {
    
  }
  
  public void handleLayerDeath() {
    
  }
  
}
