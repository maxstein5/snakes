class Food {
  private PVector pos;
  private int size;
  private int dimension;
  
  public Food(int size, int dimension) {
    pos = new PVector();
    this.size = size;
    this.dimension = dimension;
    place();
  }
  
  public PVector pos() {
   return pos; 
  }
  
  public void show(color marker) {
   fill(marker);
   rect(pos.x * size, pos.y * size, size, size);
  }
  
  public void place() {
    pos.x = floor(random(0,dimension));
    pos.y = floor(random(0,dimension));
  }
  
}
