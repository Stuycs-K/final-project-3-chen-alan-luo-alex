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
    
    BloonPropertyTable properties = bloonPropertyLookup.getProperties(layerName);
    this.propertiesTable = properties;
    
    applyProperties();
    
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
    
    // Modifiers
    this.modifiersList = new BloonModifiersList(this);
  }
  
  public Bloon(String layerName) {
    this(toSpawnParams(layerName));
  }
  
  // Spawn a bloon at a particular position
  public Bloon(String layerName, PVector position) {
    this(toSpawnParams(layerName, position));
  }
  
  public void applyProperties() {
    this.sprite = propertiesTable.getSprite().copy();
    
    this.speed = propertiesTable.getFloatProperty("speed", BASE_BLOON_SPEED);
    this.speed *= propertiesTable.getFloatProperty("speedMultiplier", 1); // There must be a speed multiplier key if no speed was defined

    this.layerHealth = propertiesTable.getIntProperty("layerHealth", 1);

    this.layerId = propertiesTable.getLayerId();
  }
  
  public boolean reachedEnd() {
    return reachedEnd;
  }
  
  public boolean isDead() {
    return isDead;
  }
  
  public PImage getSprite() {
     return sprite;
  }
  
  public void setSprite(PImage sprite) {
    this.sprite = sprite;
  }
  
  public boolean shouldRemove() {
    return isDead || reachedEnd; 
  }
  
  public PVector getPosition() {
    return position;
  }
  
  public BloonPropertyTable getProperties() {
    return propertiesTable; 
  }
  
  public BloonModifiersList getModifiersList() {
    return modifiersList;
  }
  
  public void render() {
    if (isDead || reachedEnd) {
      return;
    }
    
    imageMode(CENTER);
    image(sprite, position.x, position.y);
  }
  
  public void setLayer(int id) {
    String layerName = bloonPropertyLookup.getLayerNameFromId(id);
    setLayer(layerName);
  }
  
  public void setLayer(String layerName) {
    BloonPropertyTable properties = bloonPropertyLookup.getProperties(layerName);
    this.propertiesTable = properties;
    
    applyProperties();
  }
  
  public void damage(float count) {
    // Just damage the layer
    if (count < layerHealth) {
      layerHealth -= count;
      return;
    }
    
    isDead = true;
    
    // We popped the layer, so make sure the excess damage propagates to all children
    float excessDamage = count - layerHealth;
    handleLayerDeath(excessDamage);
  }
  
  public void step() {
    move();
    modifiersList.stepModifiers();
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

      PVector direction = PVector.sub(segment.getEnd(), segment.getStart()).normalize();
      
      float remainingDistanceToEnd = PVector.dist(position, segment.getEnd());
      
      if (totalDistanceToMove <= remainingDistanceToEnd) {
        position.add(direction.mult(totalDistanceToMove));
        break;
      } else {
        position = segment.getEnd().copy();
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
  
  public void handleLayerDeath(float excessDamage) {
    JSONArray children = propertiesTable.getChildren();
    
    // No children to spawn (i.e. we popped a red bloon)
    if (children == null) {
      return; 
    }
    
    for (int i = 0; i < children.size(); i++) {
      JSONObject childrenSpawnInformation = children.getJSONObject(i);
      ArrayList<Bloon> spawnedChildren = bloonSpawner.spawnChildren(childrenSpawnInformation, this);
      
      // Potentially very, very laggy !
      if (excessDamage > 0) {
        for (Bloon childBloon : spawnedChildren) {
          childBloon.damage(excessDamage); 
        }
      }
      
    }
  }
  
}
