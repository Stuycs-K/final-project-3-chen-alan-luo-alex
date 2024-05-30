public class HealthManager {
  private int maxHealth;
  private int currentHealth;
  
  private HealthGui gui;
  
  public HealthManager(int maxHealth) {
    this.maxHealth = maxHealth;
    this.gui = new HealthGui();
    
    setHealth(maxHealth);
  }
  
  public int getCurrentHealth() {
    return currentHealth;
  }
  
  public int getMaxHealth() {
    return maxHealth;
  }
  
  public void setHealth(int health) {
    currentHealth = health;
    
    gui.setHealth(currentHealth);
  }
  
  public void takeDamageFromBloon(Bloon bloon) {
    BloonPropertyTable properties = bloon.getProperties();
    int damageTaken = properties.getRbe();
    
    setHealth(currentHealth - damageTaken);
  }
  
  public boolean didLose() {
    return (currentHealth <= 0);
  }
}

private class HealthGui {
  private TextLabel healthText;
  private ImageLabel healthImage;
  
  public HealthGui() {
    healthText = (TextLabel) guiManager.create("HealthDisplayTextLabel");
    healthImage = (ImageLabel) guiManager.create("HealthDisplayImageLabel");
  }
  
  public void setHealth(int health) {
    healthText.setText("" + health); 
  }
}
