public class BloonModifier {
  private float duration;
  private String name;
  private Bloon bloon;
  
  private JSONObject baseProperties;
  private JSONObject customProperties;
  
  public BloonModifier(String name, float duration) {
    this.duration = duration;
    this.name = name;
    this.baseProperties = bloonPropertyLookup.getModifier(name);
  }
  
  public BloonModifier(String name) {
    this(name, -1);
  }
  
  public void setCustomProperties(JSONObject customProperties) {
    this.customProperties = customProperties; 
  }
  
  public JSONObject getCustomProperties() {
    return customProperties;
  }
  
  // Must call this after constructor!
  public void setBloon(Bloon bloon) {
    this.bloon = bloon;
  }
  
  public Bloon getBloon() {
    return bloon;
  }
  
  public void setDuration(float duration) {
    this.duration = duration;
  }
  
  public BloonModifier clone() {
    BloonModifier copy = new BloonModifier(name, duration);
    
    if (customProperties != null) {
      copy.setCustomProperties(customProperties);
    }

    return copy;
  }
  
  public boolean isHeritable() {
    return baseProperties.getBoolean("heritable"); 
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
    drawVisuals();
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
  private static final String camoLayerPath = "images/camo.png";
  private boolean blendedImage;
  
  public Camo() {
    super("camo");
    this.blendedImage = false;
  }
  
  public Camo clone() {
    return new Camo(); 
  }
  
  public void drawVisuals() {
    if (blendedImage == true) {
      return; 
    }
    
    PImage bloonSprite = getBloon().getSprite();
    PImage camoLayerImage = loadImage(dataPath(camoLayerPath));
    //bloonSprite.mask(camoLayerImage);
    bloonSprite.blend(camoLayerImage, 0, 0, camoLayerImage.width, camoLayerImage.height, 0, 0, bloonSprite.width, bloonSprite.height, OVERLAY);
    
    PImage originalSprite = getBloon().getProperties().getSprite();
    for (int x = 0; x < originalSprite.width; x++) {
      for (int y = 0; y < originalSprite.height; y++) {
        color c = originalSprite.pixels[x + y];
        float a = alpha(c);
        
        if (a < 1e-2) {
          
          bloonSprite.pixels[x + y] = color(150, 0, 0, 0);
        }
      }
    }
    bloonSprite.updatePixels();
    
    blendedImage = true;
  }
}

public class Regrow extends BloonModifier {
  private int regrowRate; // 1 layer per this number of ticks
  private int cooldown;
  
  public Regrow(String maxLayerName) {
    super("regrow");
    
    JSONObject properties = new JSONObject();
    properties.setString("maxLayerName", maxLayerName);
    
    super.setCustomProperties(properties);
    
    this.regrowRate = 60;
    this.cooldown = 0;
  }
  
  public Regrow(String maxLayerName, int regrowRate) {
    this(maxLayerName);
    this.regrowRate = regrowRate;
  }
  
  public Regrow clone() {
    Regrow newModifier = new Regrow(getCustomProperties().getString("maxLayerName"));
    
    return newModifier;
  }
  
  public void drawVisuals() {
    
  }
  
  public int getRegrowRate() {
    return regrowRate; 
  }
  
  public void onStackAttempt(Regrow otherModifier) {
    int otherRegrowRate = otherModifier.getRegrowRate();
    if (otherRegrowRate < regrowRate) {
      regrowRate = otherRegrowRate;
    }
  }
  
  public void onStep() {
    Bloon bloon = getBloon();
    BloonPropertyTable properties = bloon.getProperties();
    
    if (properties.getLayerName().equals(getCustomProperties().getString("maxLayerName"))) {
      return;
    }
    
    if (cooldown >= regrowRate) {
      bloon.setLayer(properties.getLayerId() + 1);
      cooldown = 0;
    } else {
      cooldown++;
    }
  }
}
