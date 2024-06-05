public class CheatMenu {
  private BloonSpawnMenu bloonSpawnMenu;
  
  public CheatMenu() {
    bloonSpawnMenu = new BloonSpawnMenu();
  }
  
}

public class BloonSpawnMenu {
  private class BloonSpawnButton extends ImageButton {
    public BloonSpawnButton(JSONObject definition) {
      super(definition);
    }
  }
  
  private static final int BUTTONS_PER_ROW = 5;
  private static final int ROW_PADDING = 5;
  private static final int COLUMN_PADDING = 5;
  
  private ArrayList<BloonSpawnButton> buttons;
  
  public BloonSpawnMenu() {
    buttons = new ArrayList<BloonSpawnButton>();
    
    for (BloonPropertyTable table : bloonPropertyLookup.getPropertyTables()) {
      ImageButton baseButton = (ImageButton) guiManager.create("SpawnBloonButton");
    }
  }
}
