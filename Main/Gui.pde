static final String[] GUI_DEFINITION_FILES = new String[] {"game.json", "towerUi.json"};

private class ZIndexSorter implements Comparator<GuiBase> {
  public int compare(GuiBase a, GuiBase b) {
    return a.getZIndex() - b.getZIndex();
  }
}

private class FontManager {
  private HashMap<String, PFont> fontMap;
  
  public FontManager() {
    fontMap = new HashMap<String, PFont>();
    
    JSONObject schema = loadJSONObject("guiDefinitions/schema.json");
    JSONObject fonts = schema.getJSONObject("fonts");

    Set<String> fontAliases = fonts.keys();
    for (String alias : fontAliases) {
      JSONObject fontInfo = fonts.getJSONObject(alias);
      
      String fontPath = fontInfo.getString("path");
      int fontSize = fontInfo.getInt("size");
      
      PFont loadedFont = createFont("fonts/" + fontPath, fontSize);
      fontMap.put(alias, loadedFont);
    }
  }
  
  public PFont getFont(String alias) {
    return fontMap.get(alias);
  }
}

public class GuiManager {
  private ArrayList<GuiBase> guiList;
  private HashMap<String, GuiBase> guiTemplateMap;
  private FontManager fontManager;
  
  public GuiManager() {
    guiList = new ArrayList<GuiBase>();
    guiTemplateMap = new HashMap<String, GuiBase>();
    fontManager = new FontManager();
        
    for (String path : GUI_DEFINITION_FILES) {
      loadGui("guiDefinitions/" + path);
    }
  }
  
  
  public void mouseMoved() {
    for (GuiBase gui : guiList) {
      if (gui.isMouseInBounds()) {
        gui.onHover();
      } else {
        gui.onLeave(); 
      }
    }
  }
  
  public boolean mousePressed() {
    boolean pressedSomething = false;
    
    for (GuiBase gui : guiList) {
      if (!gui.isButton()) {
        continue;
      }
      
      if (!gui.isMouseInBounds()) {;
        continue;
      }
      
      Button button = (Button) gui;
      button.onInput();
      
      pressedSomething = true;
    }
    
    return pressedSomething;
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
        case "Frame":
          guiObject = new Frame(guiData);
          break;
        case "ImageButton":
          guiObject = new ImageButton(guiData);
          break;
        case "TextButton":
          guiObject = new TextButton(guiData);
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
      // Don't render invisible components!
      if (!gui.isVisible()) {
        continue;
      }
      
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

// Utilities for parsing JSON
private static int readInt(JSONObject object, String keyName, int defaultValue) {
  if (object.isNull(keyName)) {
    return defaultValue;
  }
  
  try {
    return object.getInt(keyName);
  } catch (Exception exception) {
    return defaultValue;
  }
}

/*
  Reading positions:
  
  1) Absolute:
    Relative to the top left corner of the window
    Implied when using integers
    
  2) Center:
    Relative to the center of the window (width / 2, height / 2)
    Enter the position as a string beginning with "c":
      An x position of "c 100" would be equivalent to width / 2 + 100 (100 pixels right of the center)
      A y position of "c -60" would be equivalent to height / 2 - 60 (60 pixels above the center)
      
  3) Right:
    Relative to the bottom right corner of the window (width, height)
   
    Enter the position as a string beginning with "r" (note that negative integers are invalid!):
      An x position of "r 60" would be equivalent to width - 60 (60 pixels to the left of the right)
      A y position of "r 40" would be equivalent to height - 40 (40 pixels above the bottom)

*/
private static int readPosition(JSONObject object, String keyName, int relativePosition) {
  int position = readInt(object, keyName, Integer.MIN_VALUE);
  
  // We entered the position as an integer! We're done.
  if (position != Integer.MIN_VALUE) {
    return position;
  }
  
  // There HAS to be a position string
  String positionString = readString(object, keyName, "");
  String[] instructions = positionString.split(" ");
  
  String relativeTo = instructions[0];
  int offset = Integer.parseInt(instructions[1]);
  
  if (relativeTo.equals("c")) {
    return relativePosition / 2 + offset; 
  }
  
  if (relativeTo.equals("r")) {
    return relativePosition - offset;
  }
  
  return 0;
}

private int readXPosition(JSONObject object, String keyName) {
  return readPosition(object, keyName, width);
}

private int readYPosition(JSONObject object, String keyName) {
  return readPosition(object, keyName, height);
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

private static float readFloat(JSONObject object, String keyName, float defaultValue) {
  if (object.isNull(keyName)) {
    return defaultValue;
  }
  
  try {
    return object.getFloat(keyName);
  } catch (Exception exception) {
    return defaultValue;
  }
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

public static boolean isInBoundsOfRectangle(int x, int y, int rectX, int rectY, int rectSizeX, int rectSizeY) {
   return (x > rectX - rectSizeX && x < rectX + rectSizeX) && (y > rectY - rectSizeY && y < rectY + rectSizeY);
}

public class GuiBase {
  private color backgroundColor;
  private float backgroundTransparency; // 0 is fully transparent, 1 is fully solid
  
  private PVector position;
  private PVector size;
  
  private boolean isVisible;
  
  private JSONObject definition;
  
  private int zIndex; // The draw order; higher values will render above lower values (100 ZIndex will be on top of 0 ZIndex)
  
  public GuiBase(JSONObject definition) {
    this.definition = definition;
    
    this.isVisible = true;
    updateProperties();
  }
  
  public JSONObject getDefinition() {
    return definition;
  }
    
  public boolean isMouseInBounds() {
    return isInBoundsOfRectangle(mouseX, mouseY, int(this.position.x), int(this.position.y), int(this.size.x), int(this.size.y));
  }
  
  public boolean isButton() {
    return false;
  }
  
  public PVector getPosition() {
    return position;
  }
  
  public PVector getSize() {
    return size;
  }
  
  public int getZIndex() {
    return zIndex;
  }
  
  public void setVisible(boolean state) {
    isVisible = state; 
  }
  
  public boolean isVisible() {
    return isVisible;
  }
  
  public void setPosition(PVector position) {
    this.position = position;
  }
  
  public void updateProperties() {
    int xPosition = readXPosition(definition, "x");
    int yPosition = readYPosition(definition, "y");
    
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
  
  // Called when mouse enters bounds
  public void onHover() {
    return;
  }
  
  // Called when mouse leaves bounds
  public void onLeave() {
    return;
  }
  
  private void renderStroke() {
    if (definition.isNull("stroke")) {
      // Reset stroke drawing things to default
      strokeJoin(MITER);
      strokeWeight(1);
      stroke(0);
      return;
    }
    JSONObject strokeData = definition.getJSONObject("stroke");
    
    String strokeType = readString(strokeData, "type", "MITER");
    if (strokeType.equals("NONE")) {
      noStroke();
      return;
    }
    
    int joinMode;
    switch (strokeType) {
      case "MITER":
        joinMode = MITER;
        break;
      case "BEVEL":
        joinMode = BEVEL;
        break;
      case "ROUND":
        joinMode = ROUND;
        break;
      default:
        joinMode = MITER;
    }
    strokeJoin(joinMode);
    
    float weight = readFloat(strokeData, "weight", 4);
    strokeWeight(weight);
    
    color strokeColor = readColor(strokeData, "color");
    stroke(strokeColor);
  }
  
  public void render() {
    fill(backgroundColor);
    renderStroke();
    rect(position.x, position.y, size.x, size.y);
  }
  
  public color getBackgroundColor() {
    return backgroundColor;
  }
  
  public float getBackgroundTransparency() {
    return backgroundTransparency;
  }
}

public interface Button {
  public void onInput();
}

public class ImageLabel extends GuiBase {
  private PImage image;
  private PVector imageSize;
  private PVector imagePosition;
  private int imagePositionMode;
  
  public ImageLabel(JSONObject definition) {
    super(definition);
    
    updateProperties();
  }
  
  public ImageLabel clone() {
    return new ImageLabel(getDefinition());
  }
  
  public void setImage(PImage image) {
    this.image = image;
  }
  
  public void updateProperties() {
    super.updateProperties();
    
    JSONObject definition = getDefinition();
    String imagePath = definition.getString("image");
    this.image = loadImage("images/" + imagePath);
    
    PVector defaultSize = getSize();
    int imageSizeX = readInt(definition, "imageSizeX", int(defaultSize.x));
    int imageSizeY = readInt(definition, "imageSizeY", int(defaultSize.y));
    
    this.imageSize = new PVector(imageSizeX, imageSizeY);
    
    int x = readInt(definition, "imageX", 0);
    int y = readInt(definition, "imageY", 0);
    
    this.imagePosition = new PVector(x, y);
    
    String imagePositionModeName = readString(definition, "imagePositionMode", "CORNER");
    
    switch (imagePositionModeName) {
      case "CENTER":
        this.imagePositionMode = CENTER;
        break;
      case "CORNER":
        this.imagePositionMode = CORNER;
        break;
      default:
        this.imagePositionMode = CORNER;
    }
  }
  
  public void render() {
    super.render();
    
    PVector position = getPosition();
    
    imageMode(this.imagePositionMode);
    image(this.image, position.x + this.imagePosition.x, position.y + this.imagePosition.y, this.imageSize.x, this.imageSize.y);
  }
}

public class Frame extends GuiBase {
  
  public Frame(JSONObject definition) {
    super(definition);
  }
  
  public void updateProperties(){
    super.updateProperties();
  }
    
  public Frame clone() {
    return new Frame(getDefinition());
  }
  
  public void render() {
    fill(getBackgroundColor(), getBackgroundTransparency() * 255);
    noStroke();
    PVector position = getPosition();
    PVector size = getSize();
    rect(position.x, position.y, size.x, size.y);
  }
}

public class ImageButton extends ImageLabel implements Button {
  
  public ImageButton(JSONObject defintion){
    super(defintion);
  }
  
  public ImageButton clone() {
    return new ImageButton(getDefinition());
  }
  
  public boolean isButton(){ 
    return true;
  }
  
  public void onInput() {
    return;
  }
  
}

public class TextButton extends TextLabel implements Button {
  
  public TextButton(JSONObject defintion){
    super(defintion);
  }
  
  public TextButton clone() {
    return new TextButton(getDefinition());
  }
  
  public boolean isButton(){ 
    return true;
  }
  
  public void onInput() {
    return;
  }
  
}

public class TextLabel extends GuiBase {
  private String text;
  private int textSize;
  private PVector textPositionOffset;
  private color textColor;
  private int textXAlignment;
  private int textYAlignment;
  
  private PFont textFont;
  
  public TextLabel(JSONObject definition) {
    super(definition);
  }
  
  public TextLabel clone() {
    return new TextLabel(getDefinition());
  }
  
  public void setText(String text) {
    this.text = text;
  }
  
  public void setTextColor(color textColor) {
    this.textColor = textColor;
  }
  
  public void updateProperties() {
    super.updateProperties();
    
    JSONObject definition = getDefinition();
    this.textSize = readInt(definition, "textSize", 18);
    
    int xOffset = readInt(definition, "textXOffset", 0);
    int yOffset = readInt(definition, "textYOffset", 0);
    
    this.textPositionOffset = new PVector(xOffset, yOffset);
    this.textColor = readColor(definition, "textColor");
    this.text = readString(definition, "text", "");
    
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
        this.textYAlignment = TOP;
    }
        
    String textFontAlias = readString(definition, "textFont", "regular");
    // Use the default processing font otherwise
    if (!textFontAlias.equals("DEFAULT")) {
      this.textFont = fontManager.getFont(textFontAlias);
    }
  }
  
  public void render() {
    super.render();
    
    fill(this.textColor);

    if (this.textFont != null) {
      textFont(this.textFont);
    } else {
      textSize(this.textSize);
    }

    PVector position = getPosition();
    textAlign(this.textXAlignment, this.textYAlignment);
    text(this.text, position.x + this.textPositionOffset.x, position.y + this.textPositionOffset.y);

  }
}
