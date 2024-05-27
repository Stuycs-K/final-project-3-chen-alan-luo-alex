public class TowerTargetFilter{
  
  public boolean canAttack(Bloon bloon){
    BloonModifiersList modifiersList = bloon.getModifiersList();
    if(modifiersList.hasModifier("camo")){
      return false;
    }
    
    return true;
  }
}
