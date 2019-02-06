//For general settings:
private int size = 30;
private int snakeLength = 4;
private int seed = 5;

private boolean training = true;
private boolean showcase = false;
private boolean showAll = false;

private float mutationRate = 0.03;

private String[] files = {};

//More specific settings:
private boolean newPop = false;
private int popSize = 4;

private boolean save = false;
private String name = "";
private int fromEach = 2;
private int speed = 10;

Population main;
World board;

void setup() {
  if (training) {
    this.size = 30;
    if(files.length < 1) {
      this.newPop = true;
      this.fromEach = this.popSize;
    } else {
      this.newPop = false;
      this.fromEach = this.popSize/files.length;
    }
    this.popSize = 4000;
    this.save = true;
  } else if (showcase) {
    this.size = 30;
    this.newPop = false;
    this.popSize = files.length + 1;
    this.save = false;
    this.fromEach = this.popSize/files.length;
    this.showAll = true;
    this.mutationRate = 0.02;
  } else {
    this.size = 50;
    this.newPop = true;
    this.popSize = 2000;
    this.save = false;
    this.fromEach = 0;
  }
  
 randomSeed(seed);
  
 if(newPop) {
   main = new Population(popSize,size,snakeLength);
 } else {
   this.name += files[0];
   for(int i = 1; i < files.length; i++) {
     this.name += " and " + files[i]; 
   }
   main = new Population(popSize,size,snakeLength, fromEach, files);
 }
 
 size(1200,900); 

 board = new World(size,main);
 board.newGen();
}

void draw() {  
  main.update(mutationRate);
  if(save) {
    if(name == "") {
        main.playerOne().brain().saveToCSV(Integer.toString(seed));
    } else {
        main.playerOne().brain().saveToCSV(name);
    }
  }
  
  board.update();
  main.show(showAll);
}

void keyPressed() {
  switch(key) {
  case '+'://speed up frame rate
    speed += 1;
    frameRate(speed);
    break;
  case '-'://slow down frame rate
    if (speed > 1) {
      speed -= 1;
      frameRate(speed);
    }
  }
}
