public class CurrencyManager {
  private float currency;
  private CurrencyGui gui;
  
  public CurrencyManager() {
    this.gui = new CurrencyGui();
    setCurrency(0);
  }
  
  public void rewardCurrency(float amount) {
    setCurrency(currency + amount);
  }
  
  public void setCurrency(float currency) {
    this.currency = currency;
    
    gui.setCurrencyText(this.currency);
  }
  
  public float getCurrency() {
    return currency;
  }
  
  public void removeCurrency(float amount) {
    setCurrency(currency - amount);
  }
}

private class CurrencyGui {
  private TextLabel currencyText;
  private ImageLabel currencyIcon;
  
  public CurrencyGui() {
    this.currencyText = (TextLabel) guiManager.create("CurrencyTextLabel");
    this.currencyIcon = (ImageLabel) guiManager.create("CurrencyImageLabel");
  }
  
  public void setCurrencyText(float currency) {
    int roundedDown = int(currency);
    currencyText.setText("$" + roundedDown);
  }
}
