public class MapSegment {
  public PVector[] vertices;
  public PVector start;
  public PVector end;
  
  public MapSegment(PVector start, PVector end, float segmentWidth) {
    vertices = new PVector[4];
    this.start = start;
    this.end = end;
    
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
  
  public boolean isBetweenStartAndEnd(PVector position) {
    float startToPositionDistance = PVector.dist(start, position);
    float positionToEndDistance = PVector.dist(position, end);
    float totalDistance = PVector.dist(start, position);
    
    float compareDistance = startToPositionDistance + positionToEndDistance;
    
    return Math.abs(compareDistance - totalDistance) < 1e-3;
  }
  
  // https://stackoverflow.com/questions/2752725/finding-whether-a-point-lies-inside-a-rectangle-or-not
  public boolean isInBounds(PVector position) {
    PVector a = vertices[0];
    PVector b = vertices[1];
    PVector d = vertices[3];
    
    PVector ab = PVector.sub(b, a);
    PVector ad = PVector.sub(d, a);
    
    if ((position.x - a.x) * ab.x + (position.y - a.y) * ab.y < 0) {
      return false;
    }
    
    if ((position.x - b.x) * ab.x + (position.y - b.y) * ab.y > 0) {
      return false;
    }
    
    if ((position.x - a.x) * ad.x + (position.y - a.y) * ad.y < 0) {
      return false;
    }
    
    if ((position.x - b.x) * ad.x + (position.y - b.y) * ad.y > 0) {
      return false;
    }

    return true;
  }
  
}
