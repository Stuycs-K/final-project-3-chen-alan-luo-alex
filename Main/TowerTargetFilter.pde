public class TowerTargetFilter{
  private boolean canDetectCamo;
  
  public TowerTargetFilter(){
    this.canDetectCamo = false;
  }
  
  public void setCamoDetection(boolean canDetectCamo){
    this.canDetectCamo = true;
  }
  
  public boolean canAttack(Bloon bloon){
    BloonModifiersList modifiersList = bloon.getModifiersList();
    if(modifiersList.hasModifier("camo")){
      return false;
    }
    
    return true;
  }
}
