class Player {
  
  //transient traits
  private boolean dead = false;
  
  //permanent traits
  private final int BLOCK_SIZE;
  private final int FRAME;
  private final int STARTING_LEN;
  private final int DIM;
  private int ID;
  private Network brain;
  private Food food;
  private color marker = color(random(255),random(255),random(255));
  
  //trackers
  private int lifetime = 0;
  private double fitness = 0;
  private ArrayList<PVector> pos;
  private int dir = 3;
  private int len;
  private int countDown = 500;
  private int[][][] board;
  
//------------------------------------------------------------------- constructor

  public Player(int FRAME, int BLOCK_SIZE, int len, int[][][] board, int ID) {
    pos = new ArrayList<PVector>();
    brain = new Network(14,10,4);
    
    this.ID = ID;
    this.BLOCK_SIZE = BLOCK_SIZE;
    this.DIM = FRAME/BLOCK_SIZE;
    this.len = len;
    this.STARTING_LEN = len;
    this.food = new Food(BLOCK_SIZE, DIM, board, ID);
    this.FRAME = FRAME;
    this.board = board;
    
    init(floor(DIM/2),floor(DIM/2), len);
  }
  
  private void init(int xpos, int ypos, int length) {
    for(int i = 0; i < length; i++) {
      pos.add(new PVector(xpos + i,ypos));
      board[(int)head().x][(int)head().y][ID] = marker;
    }
  }
  
//-------------------------------------------------------------------- show
  
  public void show() {    
      food.show(marker);
      fill(color(marker));
      for(int i = 0; i < pos.size(); i++) {
        rect(pos.get(i).x*BLOCK_SIZE,pos.get(i).y*BLOCK_SIZE,BLOCK_SIZE,BLOCK_SIZE);
      }
  }
   
//-------------------------------------------------------------------- move
  
  public void move() {
    calculateFitness();
    
    int head = pos.size() - 1;
    PVector front = head();
    getDirection();
    if(countDown == 0) {
     die(); 
    } else {
    
    board[(int)pos.get(0).x][(int)pos.get(0).y][ID] = 0;
    pos.remove(0);
    
    switch (dir) {
      case 0: die();
              break;
              
      //move right
      case 1: checkPos(front.x + 1, front.y);
              pos.add(new PVector(front.x + 1,front.y));
              if (head().x > DIM - 1) {
                  pos.set(head,new PVector(DIM - 1,front.y));
                  die();
              }
              break;   
      
      //move down        
      case 2: checkPos(front.x, front.y + 1);
              pos.add(new PVector(front.x,front.y + 1));
              if (head().y > DIM - 1) {
                  pos.set(head,new PVector(front.x,DIM - 1));
                  die();
              }
              break;  
       
       //move left
       case 3: checkPos(front.x - 1, front.y);
              pos.add(new PVector(front.x - 1,front.y));
              if (head().x < 0) {
                  pos.set(head,new PVector(0,front.y));
                  die();
              }
              break;
              
      //move up        
      case 4: checkPos(front.x, front.y - 1);
              pos.add(new PVector(front.x,front.y - 1));
              if (head().y < 0) {
                  pos.set(head,new PVector(front.x,0));
                  die();
              }
              break;
    }
    
    if(!dead) {
      board[(int)head().x][(int)head().y][ID] = marker;
    }
    countDown--;
    }
  }
  
//-------------------------------------------------------------------- check next position for death or win
  
  private void checkPos(float x, float y) {
    PVector at = new PVector(x,y);
    
    if (pos.contains(at)) {
      die();
    } else if (food.pos().x == x && food.pos().y == y) {
      grow();  
      food.place(board);
    }
  }
  
//-------------------------------------------------------------------- die and grow
 
  private void die() {
    for(int i = 0; i < len-1; i++) {
      board[(int)pos.get(i).x][(int)pos.get(i).y][ID] = 0;
    }
    dead = true;
  }

  private void grow() {
    pos.add(0,new PVector(pos.get(0).x + (pos.get(1).x - pos.get(0).x),pos.get(0).y + (pos.get(1).y - pos.get(0).y)));
    board[(int)pos.get(0).x][(int)pos.get(0).y][ID] = marker;
    len++;
    countDown = 500;
  }
  

//-------------------------------------------------------------------- get next direction
  
  private void getDirection() {
    float adj = 1;
    
    float wallLeft = 0;
    float wallRight = 0;
    float wallUp = 0;
    float wallDown = 0;
    
    float foodX = (float)(head().x-food.pos().x)/DIM;
    float foodY = (float)(head().y-food.pos().y)/DIM;
    
    float foodUp = 0;
    float foodDown = 0;
    float foodLeft = 0;
    float foodRight = 0;
    
    float bodyRight = 0;
    float bodyLeft = 0;
    float bodyDown = 0;
    float bodyUp = 0;
    
    PVector seeker = new PVector(head().x, head().y);
    float acc = adj;
    seeker.x += 1;
    while(!pos.contains(seeker) && seeker.x < DIM) {
      if(seeker.equals(food.pos())) foodRight = 1;
      seeker.x += 1;
      acc++;
    }
    
    if(seeker.x < DIM) {
      bodyRight = 1f/acc;
    } else {
      wallRight = 1f/acc;
    }
    
    while(seeker.x < DIM) {
      if(seeker.equals(food.pos())) foodRight = 1;
      seeker.x += 1;
      acc++;
    }
    
    wallRight = 1f/acc;
    
    seeker = new PVector(head().x, head().y);
    acc = adj;
    seeker.x -= 1;
    while(!pos.contains(seeker) && seeker.x > -1) {
      if(seeker.equals(food.pos())) foodRight = 1;
      seeker.x -= 1;
      acc++;
    }
    
    if(seeker.x > -1) {
      bodyLeft = 1f/acc;
    } else {
      wallLeft = 1f/acc;
    }
    
    while(seeker.x > -1) {
      if(seeker.equals(food.pos())) foodLeft = 1;
      seeker.x -= 1;
      acc++;
    }
    
    wallLeft = 1f/acc;
    
    seeker = new PVector(head().x, head().y);
    acc = adj;
    seeker.y += 1;
    while(!pos.contains(seeker) && seeker.y < DIM) {
      if(seeker.equals(food.pos())) foodDown = 1;
      seeker.y += 1;
      acc++;
    }
   
    if(seeker.y < DIM) {
      bodyDown = 1f/acc;
    } else {
      wallDown = 1f/acc;
    }
    
    while(seeker.y < DIM) {
      if(seeker.equals(food.pos())) foodDown = 1f/acc;
      if(seeker.equals(food.pos())) foodDown = 1;
      seeker.y += 1;
      acc++;
    }

    wallDown = 1f/acc;
    
    seeker = new PVector(head().x, head().y);
    acc = adj;
    seeker.y -= 1;
    while(!pos.contains(seeker) && seeker.y > -1) {
      if(seeker.equals(food.pos())) foodUp = 1;
      seeker.y -= 1;
      acc++;
    }
    
    if(seeker.y > -1) {
      bodyUp = 1f/acc;
    } else {
      wallUp = 1f/acc;
    }
    
    while(seeker.y > -1) {
      if(seeker.equals(food.pos())) foodUp = 1;
      seeker.y -= 1;
      acc++;
    }
    
    wallUp = 1f/acc;
    
    
    dir = brain.step(wallLeft, wallRight, wallUp, wallDown, foodLeft, foodRight, foodUp, foodDown, bodyLeft, bodyRight, bodyUp, bodyDown, foodX, foodY);
    lifetime++;
  }
  
//-------------------------------------------------------------------- mutation methods
   
 public void calculateFitness() {
   if(len < 200) {
     fitness = Math.pow(2, (floor(len)));
   } else {
     fitness = Math.pow(2, 200) * len * len;
   }
 }
 
  public Player clone(int id) {
    Player clone = new Player(FRAME, BLOCK_SIZE, STARTING_LEN, board, id);
    clone.setBrain(brain.clone());
    clone.setMarker(marker);

    return clone;
 }
 
 public void mutate(float rate) {
    brain.mutate(rate);

    float r = red(marker) + randomGaussian()*10;
    float g = green(marker) + randomGaussian()*10;
    float b = blue(marker) + randomGaussian()*10;

    marker = color(r, g, b);
  }
  
  public Player breedWith(Player parent, int id) {
    Player child = new Player(FRAME, BLOCK_SIZE, STARTING_LEN,board, id);
    child.setBrain(brain.combineWith(parent.brain()));
    child.setMarker(marker);
    return child;
  }
   
//-------------------------------------------------------------------- setters
public void setBrain(Network brain) {
  this.brain = brain; 
 }
 
 public void setMarker(color parent) {
  this.marker = parent; 
 }
 
 public void setID(int id) {
  this.ID = id; 
 }
 
//-------------------------------------------------------------------- getters
 
 public Network brain() {
   return brain;
 }
 
 public int ID() {
  return ID; 
 }
   
  public ArrayList<PVector> pos() {
   return pos; 
  }
  
 
  public double fitness() {
     return fitness;
  }
 
  private PVector head() {
    return pos.get(pos.size()-1);
  }

  public boolean dead() {
   return dead;
  }
  
  public int lifetime() {
   return lifetime; 
  }
  
  public int len() {
   return len; 
  }
  
  public color marker() {
   return marker; 
  }

}
