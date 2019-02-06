class Food {
  private PVector pos;
  private int size;
  private int dimension;
  private final int ID;
  
  public Food(int size, int dimension, IntList[][] board, int ID) {
    this.ID = ID;
    pos = new PVector();
    this.size = size;
    this.dimension = dimension;
    place(board);
  }
  
  public PVector pos() {
   return pos; 
  }
  
  public void show(color marker) {
   fill(marker);
   rect(pos.x * size, pos.y * size, size, size);
  }
  
  public void place(IntList[][] board) {
    pos.x = floor(random(0,dimension));
    pos.y = floor(random(0,dimension));
    
    while(board[(int)pos.x][(int)pos.y].hasValue(ID)) {
      pos.x = floor(random(0,dimension));
      pos.y = floor(random(0,dimension));
    }
  }
  
}