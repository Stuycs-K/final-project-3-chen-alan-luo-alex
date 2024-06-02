public class TowerTargetFilter{
  private boolean canDetectCamo;
  
  public TowerTargetFilter(){
    this.canDetectCamo = false;
  }
  
  public void setCamoDetection(boolean canDetectCamo){
    this.canDetectCamo = canDetectCamo;
  }
  
  public boolean canDetectCamo() {
    return this.canDetectCamo;
  }
  
  public boolean canAttack(Bloon bloon){
    BloonModifiersList modifiersList = bloon.getModifiersList();
    if(modifiersList.hasModifier("camo") && !this.canDetectCamo){
      return false;
    }
    
    return true;
  }
}
