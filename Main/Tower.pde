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
    public ArrayList<Projectile> projectiles;
    private TowerTargetFilter targetFilter;
    
    
    
    public Tower(int x, int y, int radius, int fireRate, int damage, int attackSpeed){
      this.x = x;
      this.y = y;
      this.radius = radius;
      this.fireRate = fireRate;
      this.damage = damage;
      this.attackSpeed = attackSpeed;
      this.upgradeLevel = 1;
      this.attackCooldown = 0;
      this.projectiles = new ArrayList<Projectile>();
      this.targetFilter = new TowerTargetFilter();
      
    }
    
    public void attack(ArrayList<Bloon> bloons){
      attackCooldown--;
      if(attackCooldown <=0){
      
        for (Bloon targetBloon: bloons){
          if(targetFilter.canAttack(targetBloon)){
            float distance = dist(x,y,targetBloon.position.x,targetBloon.position.y);
            if(distance<=radius){
              projectiles.add(new Projectile(x,y,targetBloon.position.x,targetBloon.position.y,damage));
              attackCooldown = fireRate;
              break;
            }
            }
          }
         
        }
      
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
      for(Projectile projectile : projectiles){
        projectile.drawProjectile();
      }
    }
    
    public int getCost(){
      return 0;
    }
    
  }
