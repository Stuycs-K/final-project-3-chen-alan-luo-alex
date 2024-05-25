static final int BASE_BLOON_SPEED = 100;

private static JSONObject toSpawnParams(String layerName) {
  JSONObject spawnParams = new JSONObject();
  spawnParams.setString("layerName", layerName);
  return spawnParams;
}

private static JSONObject toSpawnParams(String layerName, PVector position) {
  JSONObject spawnParams = new JSONObject();
  spawnParams.setString("layerName", layerName);
  
  JSONObject positionData = new JSONObject();
  positionData.setFloat("x", position.x);
  positionData.setFloat("y", position.y);
  
  spawnParams.setJSONObject("spawnPosition", positionData);
  return spawnParams;
}
  
public class Bloon {
  private int layerId;
  private float layerHealth;
  private float speed;
  private PImage sprite;
  private BloonModifiersList modifiersList;
  private BloonPropertyTable propertiesTable;
  
  private int positionId;
  private PVector position;
  
  private boolean isDead;
  private boolean reachedEnd;
  
  public Bloon(JSONObject spawnParams) {
    String layerName = spawnParams.getString("layerName");
    
    this.modifiersList = new BloonModifiersList(this);
    JSONObject spawnModifiers = spawnParams.getJSONObject("modifiers");
    if (spawnModifiers != null) {
      
    }
    
    BloonPropertyTable properties = bloonPropertyLookup.getProperties(layerName);
    this.propertiesTable = properties;
    
    // Setting fields from the JSON
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
    
    JSONObject spawnPosition = spawnParams.getJSONObject("spawnPosition");
    if (spawnPosition != null) {
      PVector positionVector = new PVector(spawnPosition.getFloat("x"), spawnPosition.getFloat("y"));

      this.position = positionVector;
      this.positionId = game.getMap().getSegmentIdFromPosition(positionVector);
    } else {
      // Set the bloon's position to the start
      this.positionId = 0;
      this.position = game.getMap().getPositionOfId(0);
    }
    
    
  }
  
  public Bloon(String layerName) {
    this(toSpawnParams(layerName));
  }
  
  // Spawn a bloon at a particular position
  public Bloon(String layerName, PVector position) {
    this(toSpawnParams(layerName, position));
  }
  
  public boolean reachedEnd() {
    return this.reachedEnd;
  }
  
  public boolean isDead() {
    return this.isDead;
  }
  
  public boolean shouldRemove() {
    return isDead || reachedEnd; 
  }
  
  public void render() {
    if (isDead || reachedEnd) {
      return;
    }
    
    imageMode(CENTER);
    image(sprite, position.x, position.y);
  }
  
  public void damage(float count) {
    // Just damage the layer
    if (count < layerHealth) {
      layerHealth -= count;
      return;
    }
    
    isDead = true;
    
    // We popped the layer, so make sure the excess damage propagates to all children
    float excessDamage = layerHealth - count;
    JSONArray children = propertiesTable.getChildren();
    
    // No children to spawn (i.e. we popped a red bloon)
    if (children == null) {
      return; 
    }
    
    for (int i = 0; i < children.size(); i++) {
      JSONObject childrenSpawnInformation = children.getJSONObject(i);
      bloonSpawner.spawnChildren(childrenSpawnInformation, position);
    }
  }
  
  public void step() {
    move();
    render();
  }
  
  public void move() {
    // We reached the end !
    if (positionId >= game.getMap().getSegmentCount()) {
      reachedEnd = true;
      return;
    }
    
    float totalDistanceToMove = this.speed * (1 / frameRate);
    
    while (true) {
      MapSegment segment = game.getMap().getMapSegment(positionId);

      PVector direction = PVector.sub(segment.end, segment.start).normalize();
      
      float remainingDistanceToEnd = PVector.dist(position, segment.end);
      
      if (totalDistanceToMove <= remainingDistanceToEnd) {
        position.add(direction.mult(totalDistanceToMove));
        break;
      } else {
        position = segment.end.copy();
        totalDistanceToMove -= remainingDistanceToEnd;
        
        positionId += 1;
        
        // We reached the end
        if (positionId >= game.getMap().getSegmentCount()) {
          reachedEnd = true;
          return;
        }
      }
      
    }
  }
  
  public void handleLayerDeath() {
    
  }
  
}
