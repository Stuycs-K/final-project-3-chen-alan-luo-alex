static final PVector END_POSITION = new PVector(-1e5, -1e5);

public class Map {
  private float pathWidth;
  private ArrayList<PVector> pathWaypointArray;
  
  private ArrayList<MapSegment> mapSegments;
  
  public Map(ArrayList<PVector> pathWaypointArray, float pathWidth) {
    this.pathWaypointArray = pathWaypointArray;
    this.pathWidth = pathWidth;
    
    this.mapSegments = new ArrayList<MapSegment>();
    
    for (int i = 0; i < this.pathWaypointArray.size() - 1; i++) {
      PVector currentPosition = this.pathWaypointArray.get(i);
      PVector nextPosition = this.pathWaypointArray.get(i + 1);
      
      this.mapSegments.add(new MapSegment(currentPosition, nextPosition, pathWidth));
    }
  }
  
  public PVector getNextPosition(int positionIndex) {
    // Return invalid position if we're at the end
    if (positionIndex + 1 >= pathWaypointArray.size()) {
      return END_POSITION;
    }
    
    return pathWaypointArray.get(positionIndex + 1);
  }
  
  public void drawPath() {
    for (MapSegment segment : mapSegments) {
       PVector[] vertices = segment.vertices;
       beginShape();
       
       for (int i = 0; i < 4; i++) {
         vertex(vertices[i].x, vertices[i].y); 
       }

       endShape(CLOSE);
    }
  }
  
  public boolean isOnPath(PVector position) {
     for (MapSegment segment : mapSegments) {
       if (segment.isInBounds(position)) {
         return true; 
       }
     }
     
     return false;
  }
  
}
