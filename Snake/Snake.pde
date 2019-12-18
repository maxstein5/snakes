//(c) Max Stein 2019

//---------------------------------------General Settings:-------------------------------------------//
private int size = 50;
private int snakeLength = 5;

private boolean training = true; //To load from csv and train snakes, then save to csv file, set true
private boolean showcase = false;  //To load snakes and show them without saving, set true
                                  //Leave both false to watch new population train without saving

private String[] files = {"3"};   //csv files to load and save to. Leave empty to generate new population to train

private boolean showAll = false;  //To look at all background snakes, set true

private int seed = 3;             //Random seed. Also the name of the csv to save to

//---------------------------------------------------------------------------------------------------//
private float mutationRate = 0.03;
private boolean newPop = false;
private int popSize = 4;

private boolean save = false;
private String name = "";
private int fromEach = 2;
private int speed = 10;

Population main;
World board;

void setup() {
   size(1200,900); 
  if (training) {
    if(files.length < 1) {
      this.newPop = true;
      this.fromEach = this.popSize;
    } else {
      this.newPop = false;
      this.fromEach = this.popSize/files.length;
    }
    this.popSize = 10000;
    this.save = true;
  } else if (showcase) {
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

 board = new World(size,main);
 board.newGen();
}

void draw() {
  board.update();
  main.show(showAll);
  
  main.update(mutationRate);
  if(save) {
    if(name == "") {
        main.playerOne().brain().saveToCSV(Integer.toString(seed));
    } else {
        main.playerOne().brain().saveToCSV(name);
    }
  }
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
