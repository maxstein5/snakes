class World {
  private int size;
  private int deaths;
  private int record;
  private IntList current;
  private IntList currentCol;
  private IntList avgCol;
  private FloatList avg;
  private int frame = height;
  private Population main;

  
  World(int size, Population main) {
   this.size = size;
   this.deaths = 0;
   this.avg = new FloatList();
   this.avgCol = new IntList ();
   this.record = 0;
   this.current = new IntList ();
   this.currentCol = new IntList ();
   this.main = main;   
  }
  
  public void update() {
    background(color(100,100,100));
    fill(255);
    stroke(255);
    
    for(int i = 0; i < size; i++) {
      for(int j = 0; j < size; j++) {
        //if(main.board()[i][j].size() > 0) {
        //  stroke(0);
        //  fill(main.board()[i][j].get(0));
        //} else {
        //  stroke(255);
        //  fill(255);
        //}
        rect(i*frame/size,j*frame/size,frame/size,frame/size);
      }
    }
    newGen();
    HUD();
  }
  
  public void newGen() {
    deaths = main.deaths();
    
    if(main.bestLength() > record) {
      record = main.bestLength();
    }
    current.append(main.bestCurLength());
    currentCol.append(main.bestColor());
    avg.append(main.average());
    avgCol.append(main.averageColor());
    
    if(current.size() > 1500) {
      current.remove(0);
      currentCol.remove(0);
      avg.remove(0);
      avgCol.remove(0);
    }
  }
  
  private void HUD() {
    fill(255);
    textSize(16);
    text("Deaths: " + deaths,frame+10,frame-40);
    text("Best Snake Length: " + record,frame+10,frame-20); 
    graph(frame+10,frame-200,280,140);
    showBrain(frame + 10,10,width-(frame)-20,500);
  }
  
  private void showBrain(int x, int y, int w, int h) {
    main.playerOne().brain().show(x,y,w,h);

    fill(230);
    int textW = 100;
    int textH = 50;
    int xpos = ((width+frame-textW)/2);
    int ypos = h + 20;
    rect(xpos,ypos,textW,textH);
    fill(0);
    textSize(textH);
    textAlign(CENTER);
    text(nf(main.playerOne().len(),3),xpos+textW/2,ypos+textH-5);
    textSize(16);
    text("Current Score",xpos+textW/2,ypos + textH + 16);
    text("Fitness: " + main.playerOne().fitness(),xpos+textW/2,ypos + textH + 32); 
    textAlign(LEFT);
    
  }
  
  private void graph(int x, int y, int w, int h) {
    fill(230);
    stroke(0);
    rect(x,y,w,h);
    int num = current.size()-1;
    int max = record;
    
    
    strokeWeight(2);
    stroke(0);
    float prevX = x;
    float prevY = y + h - (current.get(0)/ (float)max)*h;
    
    prevX = x;
    prevY = y + h - (avg.get(0)/ (float)max)*h;
    
    for(int i = 1; i <= num; i++) {
      float nextX = prevX + (float)w/num;
      float nextY = y + h - (avg.get(i)/ (float)max)*h;
      stroke(avgCol.get(i));
      line(prevX,prevY,nextX,nextY);
      prevX = nextX;
      prevY = nextY;
    }
    
    prevX = x;
    prevY = y + h - (current.get(0)/ (float)max)*h;
    
    for(int i = 1; i <= num; i++) {
      float nextX = prevX + (float)w/num;
      float nextY = y + h - (current.get(i)/ (float)max)*h;
      stroke(currentCol.get(i));
      line(prevX,prevY,nextX,nextY);
      prevX = nextX;
      prevY = nextY;
    }
}
    
  }
  
