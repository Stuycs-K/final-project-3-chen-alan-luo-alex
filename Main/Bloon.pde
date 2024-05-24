static final int BASE_BLOON_SPEED = 200;

public class Bloon {
  private int layerId;
  private float layerHealth;
  private float speed;
  private PImage sprite;
  private BloonModifiersList modifiersList;
  
  private int positionId;
  private int targetPositionId;
  private PVector position;
  
  public Bloon(String layerName) {
    this.modifiersList = new BloonModifiersList(this);
    
    BloonPropertyTable properties = bloonPropertyLookup.getProperties(layerName);
    
    this.sprite = properties.getSprite();
    
    this.speed = properties.getFloatProperty("speed"); // Try to set base speed
    if (this.speed == NULL_FLOAT) { // There must be a speed multiplier key if no speed was defined
      float speedMultiplier = properties.getFloatProperty("speedMultiplier");
      this.speed = BASE_BLOON_SPEED * speedMultiplier;
    }
    
    this.layerHealth = properties.getIntProperty("layerHealth");
    if (this.layerHealth == NULL_INT) { // Default layer health is 1
      this.layerHealth = 1;
    }
    
    this.layerId = properties.getLayerId();
    
    // Set the bloon's position to the start
    this.positionId = 0;
    this.targetPositionId = 1;
    this.position = game.getMap().getPositionOfId(0);
  }
  
  // Spawn a bloon at a particular position
  public Bloon(String layerName, PVector position) {
    this(layerName);
    
    this.position = position;
    
    this.targetPositionId = game.getMap().getNextPositionId(position);
    this.positionId = this.targetPositionId - 1;
  }
  
  public void render() {
     imageMode(CENTER);
     image(sprite, position.x, position.y);
  }
  
  public void damage(float count) {
    
  }
  
  public void step() {
    move();
    render();
  }
  
  public void move() {
    // We reached the end !
    if (positionId >= game.getMap().getSegmentCount()) {
      return;
    }
    
    float totalDistanceToMove = this.speed * (1 / frameRate);
    
    while (true) {
      MapSegment segment = game.getMap().getMapSegment(positionId);
      println("se" + positionId);
      PVector direction = PVector.sub(segment.end, segment.start).normalize();
      
      float remainingDistanceToEnd = PVector.dist(position, segment.end);
      
      if (totalDistanceToMove <= remainingDistanceToEnd) {
        position.add(direction.mult(totalDistanceToMove));
        break;
      } else {
        position = segment.end;
        totalDistanceToMove -= remainingDistanceToEnd;
        
        positionId += 1;
        
        // We reached the end
        if (positionId >= game.getMap().getSegmentCount()) {
          return;
        }
        
        targetPositionId += 1;
      }
      
    }
  }
  
  public void handleLayerDeath() {
    
  }
  
}
