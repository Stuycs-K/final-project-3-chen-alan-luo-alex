public class HealthManager {
  private int maxHealth;
  private int currentHealth;
  
  public HealthManager(int maxHealth) {
    this.maxHealth = maxHealth;
    this.currentHealth = maxHealth;
  }
  
  public int getCurrentHealth() {
    return currentHealth;
  }
  
  public int getMaxHealth() {
    return maxHealth;
  }
  
  public void setHealth(int health) {
    currentHealth = health;
  }
  
  public void takeDamageFromBloon(Bloon bloon) {
    BloonPropertyTable properties = bloon.getProperties();
    int damageTaken = properties.getRbe();
    
    currentHealth -= damageTaken;
  }
  
  public boolean didLose() {
    return (currentHealth <= 0);
  }
}
