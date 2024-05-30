public class CurrencyManager {
  private float currency;
  private CurrencyGui gui;
  
  public CurrencyManager() {
    this.currency = 0; 
    this.gui = new CurrencyGui();
  }
  
  public void rewardCurrency(float amount) {
    this.currency += amount; 
  }
  
  public void setCurrency(float currency) {
    this.currency = currency;
  }
  
  public float getCurrency() {
    return currency;
  }
  
  public void removeCurrency(float amount) {
    this.currency -= amount;
  }
}

private class CurrencyGui {
  public CurrencyGui() {
    
  }
}
