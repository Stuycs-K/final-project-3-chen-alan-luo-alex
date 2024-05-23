void setup() {
  size(1000, 700);
  ArrayList<PVector> positions = new ArrayList<PVector>();
  positions.add(new PVector(0, 500));
  positions.add(new PVector(500, 500));
  positions.add(new PVector(500, 250));
  positions.add(new PVector(700, 250));
  Map map = new Map(positions, 20);
  map.drawPath();
  
}
