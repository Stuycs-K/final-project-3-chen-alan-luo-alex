public class CheatMenu {
  private BloonSpawnMenu bloonSpawnMenu;
  public boolean isEnabled;
  
  public CheatMenu() {
    bloonSpawnMenu = new BloonSpawnMenu();
    
    isEnabled = false;
  }
  
  public void setVisible(boolean state) {
    bloonSpawnMenu.setVisible(state);
    this.isEnabled = state;
  }
}

public class BloonSpawnMenu {
  private static final int BUTTONS_PER_ROW = 5;
  private static final int ROW_PADDING = 5;
  private static final int COLUMN_PADDING = 5;
  
  private ArrayList<BloonSpawnButton> buttons;
  private CamoButton toggleCamoButton;
  private RegrowButton toggleRegrowButton;
  
  private class BloonSpawnButton extends ImageButton {
    private String layerName;
    private BloonPropertyTable layerProperties;
    private JSONObject currentSpawnParams;
    
    public BloonSpawnButton(JSONObject definition) {
      super(definition);
      
      this.currentSpawnParams = new JSONObject();
      this.currentSpawnParams.setJSONObject("modifiers", new JSONObject());
    }
    
    public void setLayerName(String name) {
      this.layerName = name;
      this.layerProperties = bloonPropertyLookup.getProperties(this.layerName);
      
      currentSpawnParams.setString("layerName", this.layerName);
      
      setImage(layerProperties.getSprite());
    }
    
    public void setCamo(boolean state) {
      if (state) {
        
      } else {
        setImage(layerProperties.getSprite());
      }
    }
    
    public void setRegrow(boolean state) {
      if (state) {
        
      } else {
        setImage(layerProperties.getSprite());
      }
    }
    
    public void onInput() {
      
    }
  }
  
  private class CamoButton extends ImageButton {
    private boolean enabled;
    
    public CamoButton(JSONObject definition) {
      super(definition);
      this.enabled = false;
    }
    
    public void onInput() {
      
    }
  }
  
  private class RegrowButton extends ImageButton {
    private boolean enabled;
    
    public RegrowButton(JSONObject definition) {
      super(definition);
      this.enabled = false;
    }
    
    public void onInput() {
      
    }
  }

  public BloonSpawnMenu() {
    this.toggleCamoButton = new CamoButton(guiManager.getGuiDefinition("ToggleCamoButton"));
    guiManager.createCustom((GuiBase) this.toggleCamoButton);
   
    this.toggleRegrowButton = new RegrowButton(guiManager.getGuiDefinition("ToggleRegrowButton"));
    guiManager.createCustom((GuiBase) this.toggleRegrowButton);
    
    buttons = new ArrayList<BloonSpawnButton>();
    
    int count = 0;
    for (BloonPropertyTable table : bloonPropertyLookup.getPropertyTables()) {
      BloonSpawnButton spawnButton = new BloonSpawnButton(guiManager.getGuiDefinition("SpawnBloonButton"));
      guiManager.createCustom((GuiBase) spawnButton);
      
      int yMultiplier = count / BUTTONS_PER_ROW;
      int xMultiplier = count % BUTTONS_PER_ROW;
      
      float originalX = spawnButton.position.x;
      float originalY = spawnButton.position.y;
      PVector position = new PVector(originalX + (spawnButton.size.x + ROW_PADDING) * xMultiplier, originalY + (spawnButton.size.y + COLUMN_PADDING) * yMultiplier);
      spawnButton.setPosition(position);
      
      spawnButton.setLayerName(table.getLayerName());
      buttons.add(spawnButton);   
      
      count++;
    }
  }
  
  public void setVisible(boolean state) {
    toggleCamoButton.setVisible(state);
    toggleRegrowButton.setVisible(state);
    
    for (BloonSpawnButton button : buttons) {
      button.setVisible(state);
    }
  }
}
