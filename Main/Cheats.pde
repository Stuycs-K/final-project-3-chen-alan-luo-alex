public class CheatMenu {
  private BloonSpawnMenu bloonSpawnMenu;
  public boolean isEnabled;
  
  public CheatMenu() {
    bloonSpawnMenu = new BloonSpawnMenu();
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
  private JSONObject currentSpawnParams;
  
  private BloonPropertyTable layerProperties;
  
  private class BloonSpawnButton extends ImageButton {
    private String layerName;
    
    public BloonSpawnButton(JSONObject definition) {
      super(definition);
    }
    
    public void setLayerName(String name) {
      layerProperties = bloonPropertyLookup.getProperties(name);
      
      setImage(layerProperties.getSprite());
    }
    
    public void setCamo() {
      setImage(layerProperties.getSprite());
    }
    
    public void setRegrow() {
      setImage(layerProperties.getSprite());
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
    
    for (BloonPropertyTable table : bloonPropertyLookup.getPropertyTables()) {
      BloonSpawnButton spawnButton = new BloonSpawnButton(guiManager.getGuiDefinition("SpawnBloonButton"));
      guiManager.createCustom((GuiBase) spawnButton);
      
      spawnButton.setLayerName(table.getLayerName());
      buttons.add(spawnButton);   
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
