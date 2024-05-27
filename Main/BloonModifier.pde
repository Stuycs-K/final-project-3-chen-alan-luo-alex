public class BloonModifier {
  private float duration;
  private String name;
  private Bloon bloon;
  private JSONObject properties;
  
  public BloonModifier(String name, float duration) {
    this.duration = duration;
    this.name = name;
    this.properties = bloonPropertyLookup.getModifier(name);
  }
  
  public BloonModifier(String name) {
    this(name, -1);
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
  private float regrowRate; // Ticks
  private int maxLayerId;
  
  public Regrow() {
    super("regrow");
  }
  
  public void drawVisuals() {
    
  }
  
  public float getRegrowRate() {
    return regrowRate; 
  }
  
  public void onStackAttempt(Regrow otherModifier) {
    float otherRegrowRate = otherModifier.getRegrowRate();
    if (otherRegrowRate < regrowRate) {
      regrowRate = otherRegrowRate;
    }
  }
  
  public void onStep() {
    
  }
}
