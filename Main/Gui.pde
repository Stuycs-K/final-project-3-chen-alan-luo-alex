static final String[] guiDefinitionFiles = new String[] {"game.json"};

private class ZIndexSorter implements Comparator<GuiBase> {
  public int compare(GuiBase a, GuiBase b) {
    return a.getZIndex() - b.getZIndex();
  }
}

public class GuiManager {
  private ArrayList<GuiBase> guiList;
  private HashMap<String, GuiBase> guiTemplateMap;
  
  public GuiManager() {
    guiList = new ArrayList<GuiBase>();
    guiTemplateMap = new HashMap<String, GuiBase>();
    
    for (String path : guiDefinitionFiles) {
      loadGui(dataPath("guiDefinitions/" + path));
    }
  }
  
  private void loadGui(String filePath) {
    JSONObject data = loadJSONObject(filePath);
    
    Set<String> guiComponentNames = data.keys();
    for (String name : guiComponentNames) {
      JSONObject guiData = data.getJSONObject(name);
      
      String className = guiData.getString("className");
      
      GuiBase guiObject;
      switch (className) {
        case "TextLabel":
          guiObject = new TextLabel(guiData);
          break;
        case "ImageLabel":
          guiObject = new ImageLabel(guiData);
          break;
        case "Button":
          guiObject = new Button(guiData);
          break;
        default:
          guiObject = new GuiBase(guiData);
      }
      
      guiTemplateMap.put(name, guiObject);
    }
  }
  
  // Copies the template
  public GuiBase create(String name) {
    GuiBase copy = getTemplate(name).clone();
    insertGui(copy);
    return copy;
  }
  
  public void render() {
    for (GuiBase gui : guiList) {
      gui.render();
    }
  }
  
  public void destroy(GuiBase object) {
    guiList.remove(object); 
  }
  
  public GuiBase getTemplate(String name) {
    return guiTemplateMap.get(name);
  }
  
  // Has to sort the list based on ZIndex
  // A binary tree would be ideal, but this will do for now and probably forever...
  private void insertGui(GuiBase gui) {
    guiList.add(gui);
    Collections.sort(guiList, new ZIndexSorter());
  }
  
  
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

private static float readFloat(JSONObject object, String keyName, float defaultValue) {
  if (object.isNull(keyName)) {
    return defaultValue;
  }
  
  return object.getFloat(keyName);
}

private color readColor(JSONObject object, String keyName) {
  String colorString = readString(object, keyName, "255 255 255 0");
  String[] colorValues = colorString.split(" ");
    
  int r = Integer.parseInt(colorValues[0]);
  int g = Integer.parseInt(colorValues[1]);
  int b = Integer.parseInt(colorValues[2]);
  int a = -1;
  if (colorValues.length == 4) {
    a = Integer.parseInt(colorValues[3]); 
  }
  
  return (a == -1) ? color(r, g, b) : color(r, g, b, a);
}

private class GuiBase {
  private color backgroundColor;
  private float backgroundTransparency; // 0 is fully transparent, 1 is fully solid
  
  private PVector position;
  private PVector size;
  
  private boolean isButton;
  private boolean isVisible;
  
  private JSONObject definition;
  
  private int zIndex; // The draw order; higher values will render above lower values (100 ZIndex will be on top of 0 ZIndex)
  
  public GuiBase(JSONObject definition) {
    this.definition = definition;
    updateProperties();
  }
  
  public JSONObject getDefinition() {
    return definition;
  }
  
  public void setButton(boolean state) {
    isButton = state;
  }
  
  public PVector getPosition() {
    return position;
  }
  
  public int getZIndex() {
    return zIndex;
  }
  
  public void setVisible(boolean state) {
    isVisible = state; 
  }
  
  public void setPosition(PVector position) {
    this.position = position;
  }
  
  public void updateProperties() {
    int xPosition = readInt(definition, "x", 0);
    int yPosition = readInt(definition, "y", 0);
    
    this.position = new PVector(xPosition, yPosition);
    
    int xSize = readInt(definition, "sizeX", 0);
    int ySize = readInt(definition, "sizeY", 0);
    
    this.size = new PVector(xSize, ySize);
    
    this.backgroundColor = readColor(definition, "backgroundColor");
    this.backgroundTransparency = readFloat(definition, "backgroundTransparency", 1);
    
    this.zIndex = readInt(definition, "zIndex", 0);
  }
  
  public GuiBase clone() {
    return new GuiBase(definition);
  }
  
  public void onHover() {
    return;
  }
  
  public void render() {
    fill(backgroundColor);
    rect(position.x, position.y, size.x, size.y);
  }
}

public class Button extends GuiBase {
  
  public Button(JSONObject definition) {
    super(definition);
  }
  
  public Button clone() {
    return new Button(getDefinition());
  }
  
  public void onClick() {
    
  }
  
  public void onRelease() {
    
  }
}

public class ImageLabel extends GuiBase {
  private PImage image;
  
  public ImageLabel(JSONObject definition) {
    super(definition);
  }
  
  public ImageLabel clone() {
    return new ImageLabel(getDefinition());
  }
  
  public void updateProperties() {
    super.updateProperties();
  }
}

public class TextLabel extends GuiBase {
  private String text;
  private int textSize;
  private PVector textPositionOffset;
  private color textColor;
  private int textXAlignment;
  private int textYAlignment;
  
  public TextLabel(JSONObject definition) {
    super(definition);
    this.text = "";
  }
  
  public TextLabel clone() {
    return new TextLabel(getDefinition());
  }
  
  public void setText(String text) {
    this.text = text;
  }
  
  public void updateProperties() {
    super.updateProperties();
    
    JSONObject definition = getDefinition();
    this.textSize = readInt(definition, "textSize", 18);
    
    int xOffset = readInt(definition, "textXOffset", 0);
    int yOffset = readInt(definition, "textYOffset", 0);
    
    this.textPositionOffset = new PVector(xOffset, yOffset);
    this.textColor = readColor(definition, "textColor");
    
    String textXAlignmentName = readString(definition, "textXAlignment", "CENTER");
    String textYAlignmentName = readString(definition, "textYAlignment", "TOP");
    
    switch (textXAlignmentName) {
      case "CENTER":
        this.textXAlignment = CENTER;
        break;
      case "LEFT":
        this.textXAlignment = LEFT;
        break;
      case "RIGHT":
        this.textXAlignment = RIGHT;
        break;
      default:
        this.textXAlignment = CENTER;
    }
    
    switch (textYAlignmentName) {
      case "CENTER":
        this.textYAlignment = CENTER;
        break;
      case "TOP":
        this.textYAlignment = TOP;
        break;
      case "BOTTOM":
        this.textYAlignment = BOTTOM;
        break;
      default:
        this.textYAlignment = CENTER;
    }
  }
  
  public void render() {
    super.render();
    
    fill(this.textColor);
    textSize(this.textSize);

    PVector position = getPosition();
    text(this.text, position.x + this.textPositionOffset.x, position.y + this.textPositionOffset.y);
    textAlign(this.textXAlignment, this.textYAlignment);
  }
}
