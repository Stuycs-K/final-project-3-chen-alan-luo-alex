public class Tower{
  public int x;
  public int y; 
  public int radius;
  public int fireRate; 
  public int damage;
  public int attackSpeed;
  public int upgradeLevel;
  public int attackCooldown;
  public String currentUpgrade;
  
  
  public Tower(int x, int y, int radius, int fireRate, int damage, int attackSpeed){
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.fireRate = fireRate;
    this.damage = damage;
    this.attackSpeed = attackSpeed;
    this.upgradeLevel = 1;
    this.attackCooldown = 0;
    
  }
  
  public void attack(ArrayList<Bloon> bloon){
  }
  
  public void upgrade(){
    this.upgradeLevel++;
  
  }
  
  public void sellTower(Game game){
     game.currency += getSellPrice();
  }
  
  public int getSellPrice(){
    return 0;
  }

  public void draw(){
    fill(255);
    ellipse(x,y,20,20);
  }
  
  public int getCost(){
    return 0;
  }
  
}
