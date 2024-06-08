static final int BASE_BLOON_SPEED = 100;
long CURRENT_BLOON_HANDLE = 0; // Cheap and dirty bloon IDs

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
  private float speedMultiplier;
  private PImage sprite;
  private float spriteRotation;
  private float distanceTraveled; // For first or last targeting
  private BloonModifiersList modifiersList;
  private BloonPropertyTable propertiesTable;
  
  private int positionId;
  private PVector position;
  
  private boolean isDead;
  private boolean reachedEnd;
  private boolean spawnedChildren;
  
  private long handle;
  private long parentHandle;
  
  public Bloon(JSONObject spawnParams) {
    String layerName = spawnParams.getString("layerName");
    
    BloonPropertyTable properties = bloonPropertyLookup.getProperties(layerName);
    this.propertiesTable = properties;
    
    this.speedMultiplier = 1;
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
    this.modifiersList.setSprite();
    
    this.spriteRotation = 0;
    
    this.reachedEnd = false;
    this.isDead = false;
    this.spawnedChildren = false;
    
    this.distanceTraveled = 0;
    
    // Assign the unique handle
    this.handle = CURRENT_BLOON_HANDLE;
    CURRENT_BLOON_HANDLE++;
    
    this.parentHandle = -1;
  }
  
  public Bloon(String layerName) {
    this(toSpawnParams(layerName));
  }
  
  // Spawn a bloon at a particular position
  public Bloon(String layerName, PVector position) {
    this(toSpawnParams(layerName, position));
  }
  
  public long getHandle() {
    return handle;
  }
  
  public long getParentHandle() {
    return parentHandle;
  }
  
  public void setParentHandle(long handle) {
    this.parentHandle = handle;
  }
  
  public void applyProperties() {
    this.sprite = propertiesTable.getSprite();
    
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
  
  public boolean isInBounds(int x, int y) {
    float sizeMultiplier = propertiesTable.getFloatProperty("size", 1);
    
    int spriteX = int(position.x - (sprite.width / 2) * sizeMultiplier);
    int spriteY = int(position.y - (sprite.height / 2) * sizeMultiplier);
    int spriteSizeX = int(sprite.width * sizeMultiplier);
    int spriteSizeY = int(sprite.height * sizeMultiplier);
    return isInBoundsOfRectangle(x, y, spriteX, spriteY, spriteSizeX, spriteSizeY);
  }
  
  public PVector[] getHitboxVertices() {
    PVector center = position;
    float sizeMultiplier = propertiesTable.getFloatProperty("size", 1);
    
    float deltaW = sprite.width / 2 * sizeMultiplier;
    float deltaH = sprite.height / 2 * sizeMultiplier;
    
    PVector[] vertices = new PVector[4];
    
    vertices[0] = new PVector(center.x - deltaW, center.y - deltaH);
    vertices[1] = new PVector(center.x + deltaW, center.y - deltaH);
    vertices[2] = new PVector(center.x + deltaW, center.y + deltaH);
    vertices[3] = new PVector(center.x - deltaW, center.y + deltaH);
    
    return vertices;
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
  
  public int getPositionId() {
    return positionId;
  }
  
  public BloonPropertyTable getProperties() {
    return propertiesTable; 
  }
  
  public BloonModifiersList getModifiersList() {
    return modifiersList;
  }
  
  public void setSpriteRotation(float rotation) {
    spriteRotation = rotation;
  }
  
  public void setSpeedMultiplier(float multiplier) {
    speedMultiplier = multiplier;
  }
  
  public void render() {
    if (isDead || reachedEnd) {
      return;
    }
    
    pushMatrix();
    
    translate(position.x, position.y);
    rotate(spriteRotation);
    
    imageMode(CENTER);
    
    image(sprite, 0, 0);
    popMatrix();
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
  
  public boolean damage(DamageProperties damageProperties) {
    return damage(damageProperties.damage, damageProperties);
  }
  
  public boolean damage(float count, DamageProperties damageProperties) {
    float finalDamage = modifiersList.getDamage(count, damageProperties);
    
    if (finalDamage == -1) {
      return false;
    }
    
    damage(finalDamage);
    return true;
  }
  
  public void damage(float count) {
    // Just damage the layer
    if (count < layerHealth) {
      layerHealth -= count;
      return;
    }
    
    if (isDead) {
      return;
    }
    
    isDead = true;
    
    // Reward 1 money
    game.getCurrencyManager().rewardCurrency(1 * game.getCurrencyPerPopMultiplier());
    
    // We popped the layer, so make sure the excess damage propagates to all children
    float excessDamage = count - layerHealth;
    handleLayerDeath(excessDamage);
    
  }
  
  public void step() {
    move();
    modifiersList.stepModifiers();
    render();
  }
  
  public float getDistanceTraveled() {
    return distanceTraveled;
  }
  
  public void setDistanceTraveled(float distanceTraveled) {
    this.distanceTraveled = distanceTraveled;
  }
  
  public void move() {
    // We reached the end !
    if (positionId >= game.getMap().getSegmentCount()) {
      reachedEnd = true;
      return;
    }
    
    if (this.speedMultiplier == 0) {
      return;
    }
    
    float totalDistanceToMove = this.speed * this.speedMultiplier * (1 / frameRate);
    this.distanceTraveled += totalDistanceToMove;
    
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
    if (children == null || spawnedChildren) {
      return; 
    }
    spawnedChildren = true;
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
