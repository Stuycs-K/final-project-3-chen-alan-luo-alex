public class CheatMenu {
  private BloonSpawnMenu bloonSpawnMenu;
  
  public CheatMenu() {
    bloonSpawnMenu = new BloonSpawnMenu();
  }
  
  public void setVisible(boolean state) {
    bloonSpawnMenu.setVisible(state);
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
  
  private class BloonSpawnButton extends ImageButton {
    public BloonSpawnButton(JSONObject definition) {
      super(definition);
    }
  }
  
  private class CamoButton extends ImageButton {
    public CamoButton(JSONObject definition) {
      super(definition);
    }
  }
  
  private class RegrowButton extends ImageButton {
    public RegrowButton(JSONObject definition) {
      super(definition);
    }
  }


  
  public BloonSpawnMenu() {
    this.toggleCamoButton = new CamoButton(guiManager.getGuiDefinition("ToggleCamoButton"));
    guiManager.createCustom((GuiBase) this.toggleCamoButton);
   
    this.toggleRegrowButton = new RegrowButton(guiManager.getGuiDefinition("ToggleRegrowButton"));
    guiManager.createCustom((GuiBase) this.toggleRegrowButton);
    
    buttons = new ArrayList<BloonSpawnButton>();
    
    for (BloonPropertyTable table : bloonPropertyLookup.getPropertyTables()) {
      ImageButton baseButton = (ImageButton) guiManager.create("SpawnBloonButton");
    }
  }
  
  public void setVisible(boolean state) {
    
  }
}
