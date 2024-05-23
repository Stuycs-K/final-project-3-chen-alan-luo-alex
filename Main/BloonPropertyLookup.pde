static ArrayList<BloonPropertyTable> tables;

public static class BloonPropertyLookup {
  
  private static boolean isNumeric(String value) {
    try {
      Integer.parseInt(value);
      return true;
    } catch (NumberFormatException exception) {
      return false;
    }
  }
  
  private static boolean isTableStart(String value) {
    return value.equals("{"); 
  }
  
  private static boolean isTableEnd(String value) {
    return value.equals("}"); 
  }
  
  private static int createBloonPropertyTable(String[] data, int bloonId, int lineStart) {
    for (int i = lineStart; i < data.length; i++) {
      String line = data[i];
      String[] keyValuePair = line.split(": ");
      
      // Probably a blank line
      if (keyValuePair.length != 2) {
        continue;
      }
      
      keyValuePair[0].trim();
      keyValuePair[1].trim();
    }
    return 0;
  }
  
  public static void initialize() {
    String[] lines = loadStrings("bloons.txt");
    
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      
      String[] keyValuePair = line.split(": ");
      
      // Probably a blank line
      if (keyValuePair.length != 2) {
        continue;
      }
      
      String keyName = keyValuePair[0];
      String value = keyValuePair[1];
      
      // Bloon entries begin with a number
      if (isNumeric(keyName)) {
        int bloonId = Integer.parseInt(keyName);
        int setIndex = createBloonPropertyTable(lines, bloonId, i);
        i = setIndex + 1;
      }
      
    }
    
  }
  
}
