static final PVector END_POSITION = new PVector(-1e5, -1e5);
static final int END_POSITION_ID = -1;

public class Map {
  private float pathWidth;
  private ArrayList<PVector> pathWaypointArray;
  private PImage mapImage;
  
  private ArrayList<MapSegment> mapSegments;
  
  public Map(ArrayList<PVector> pathWaypointArray, float pathWidth, PImage mapImage) {
    this.pathWaypointArray = pathWaypointArray;
    this.pathWidth = pathWidth;
    this.mapImage = mapImage;
    
    this.mapSegments = new ArrayList<MapSegment>();
    
    for (int i = 0; i < this.pathWaypointArray.size() - 1; i++) {
      PVector currentPosition = this.pathWaypointArray.get(i);
      PVector nextPosition = this.pathWaypointArray.get(i + 1);
      
      this.mapSegments.add(new MapSegment(currentPosition, nextPosition, pathWidth));
    }
  }
  
  public int getSegmentCount() {
    return mapSegments.size(); 
  }
  
  public PVector getStartPosition() {
    return getPositionOfId(0); 
  }
  
  public PVector getPositionOfId(int positionIndex) {
    return pathWaypointArray.get(positionIndex).copy(); 
  }
  
  public PVector getNextPosition(int positionIndex) {
    // Return invalid position if we're at the end
    if (positionIndex + 1 >= pathWaypointArray.size()) {
      return END_POSITION;
    }
    
    return pathWaypointArray.get(positionIndex + 1);
  }
  
  public int getSegmentIdFromPosition(PVector position) {
    for (int i = 0; i < mapSegments.size(); i++) {
      MapSegment segment = mapSegments.get(i);

      if (segment.isBetweenStartAndEnd(position)) {
        return i;
      }
    }
    
    return END_POSITION_ID;
  }
  
  public PVector getNextPosition(PVector position) {
    for (int i = 0; i < mapSegments.size(); i++) {
      MapSegment segment = mapSegments.get(i);
      
      if (segment.isBetweenStartAndEnd(position)) {
        return getNextPosition(i);
      }
    }
    
    return END_POSITION;
  }
  
  public MapSegment getMapSegment(int id) {
    if (id >= mapSegments.size()) {
      return null;
    }
    return mapSegments.get(id);
  }
  
  public MapSegment getMapSegmentFromPosition(PVector position) {
    for (MapSegment segment : mapSegments) {
      if (segment.isBetweenStartAndEnd(position)) {
        return segment;
      }
    }
    
    return null;
  }
  
  public void drawPath() {
    if(mapImage != null){
      image(mapImage, 0, 0);
    }
    
    for (MapSegment segment : mapSegments) {
       PVector[] vertices = segment.vertices;
       noFill();
       noStroke();
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
  
  public boolean isCircleOnPath(PVector center, float radius) {
    for (MapSegment segment : mapSegments) {
      if (segment.isCircleInBounds(center, radius)) {
        return true; 
      }
    }
   
   return false;
  }
}

public class MapSegment {
  public final PVector[] vertices;
  private final PVector start;
  private final PVector end;
  public final float distance;
  
  public MapSegment(PVector start, PVector end, float segmentWidth) {
    vertices = new PVector[4];
    this.start = start;
    this.end = end;
    this.distance = PVector.dist(start, end);
    
    PVector slope = PVector.sub(end, start).normalize();
    PVector normal = new PVector(slope.y, -slope.x);
    
    slope.mult(segmentWidth);
    normal.mult(segmentWidth);
    
    // 0: A, 1: B, 2: C, 3: D
    
    // Move width units back on the same slope and width units to the left on the perpendicular
    vertices[0] = PVector.add(start, PVector.mult(slope, -1));
    vertices[0].add(normal);
    
    vertices[1] = PVector.add(end, slope);
    vertices[1].add(normal);
    
    vertices[2] = PVector.add(end, slope);
    vertices[2].add(PVector.mult(normal, -1));
    
    vertices[3] = PVector.add(start, PVector.mult(slope, -1));
    vertices[3].add(PVector.mult(normal, -1));
  }
  
  public String toString() {
    return "MapSegment: " + start + " " + end; 
  }
  
  public PVector getStart() {
    return start; 
  }
  
  public PVector getEnd() {
    return end;
  }
  
  public boolean isBetweenStartAndEnd(PVector position) {
    float startToPositionDistance = start.dist(position);
    float positionToEndDistance = position.dist(end);
    float totalDistance = start.dist(end);
    
    float compareDistance = startToPositionDistance + positionToEndDistance;
    
    return Math.abs(compareDistance - totalDistance) < 1;
  }
  
  // https://stackoverflow.com/questions/2752725/finding-whether-a-point-lies-inside-a-rectangle-or-not
  public boolean isInBounds(PVector position) {
    return pointInRectangle(position, vertices);
  }
  
  public boolean isCircleInBounds(PVector center, float radius) {
    return circleIntersectsRectangle(center, radius, vertices);
  }
}
