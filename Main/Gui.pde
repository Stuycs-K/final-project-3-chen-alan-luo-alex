public class GuiRender {
  
}

private static int readInt(JSONObject object, String keyName, int defaultValue) {
  if (object.isNull(keyName)) {
    return defaultValue;
  }
  
  return object.getInt(keyName);
}

private static String readString(JSONObject object, String keyName, String defaultValue) {
  if (object.isNull(keyName)) {
    return defaultValue;
  }
  
  return object.getString(keyName);
}

private static boolean readBoolean(JSONObject object, String keyName, boolean defaultValue) {
  if (object.isNull(keyName)) {
    return defaultValue;
  }
  
  return object.getBoolean(keyName);
}

private static int readFloat(JSONObject object, String keyName, float defaultValue) {
  if (object.isNull(keyName)) {
    return defaultValue;
  }
  
  return object.getFloat(keyName);
}

private class GuiBase {
  private color backgroundColor;
  private float backgroundTransparency; // 0 is fully transparent, 1 is fully solid
  
  private PVector position;
  private PVector size;
  
  private boolean isButton;
  
  private int zIndex;
  
  public GuiBase(JSONObject definition) {
    updateProperties(definition);
  }
  
  public void setButton(boolean state) {
    isButton = state;
  }
  
  public void updateProperties(JSONObject definition) {
    int xPosition = readInt(definition, "x", 0);
    int yPosition = readInt(definition, "y", 0);
    
    this.position = new PVector(xPosition, yPosition);
    
    int xSize = readInt(definition, "sizeX", 0);
    int ySize = readInt(definition, "sizeY", 0);
    
    this.size = new PVector(xSize, ySize);
    
    String backgroundColor = readString(definition, "backgroundColor", "0 0 0 0");
    String[] colorValues = backgroundColor.split(" ");
    
    int r = Integer.parseInt(colorValues[0]);
    int g = Integer.parseInt(colorValues[1]);
    int b = Integer.parseInt(colorValues[2]);
    int a = -1;
    if (colorValues.length == 4) {
      a = Integer.parseInt(colorValues[3]); 
    }
    
    this.backgroundColor = (a == -1) ? color(r, g, b) : color(r, g, b, a);
    this.backgroundTransparency = readFloat(definition, "backgroundTransparency", 1);
    
    this.zIndex = readFloat(definition, "zIndex", 1);
  }
  
  public void render() {
    
  }
}

public class ImageLabel extends GuiBase {
  private PImage image;
  
  public ImageLabel(JSONObject definition) {
    super(definition);
  }
}

public class TextLabel extends GuiBase {
  private String text;
  
  public TextLabel(JSONObject definition) {
    super(definition);
  }
  
  public void setText(String text) {
    this.text = text;
  }
}
