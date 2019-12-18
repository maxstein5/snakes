class Population{
 private Player[] players;
 private Player currentBest;
 private Player allTime;
 private int deaths = 0;
 private float fitnessSum = 0;
 private double bestFitAll = 0;
 private int bestLen = 0;
 
 
 Population(int size, int dim, int snakeLength, int numEach, String... fromFile) {
  
  bestLen = snakeLength; 
   
  players = new Player[size];
  for(int i = 0; i < size; i++) {
   players[i] = new Player(height,height/dim,snakeLength);
  }
  
  for(int i = 0; i < fromFile.length; i++) {
    for(int j = 0; j < numEach; j++) {
      players[i*numEach + j].setBrain(players[i*numEach + j].brain().readFromCSV(fromFile[i]));
    }
  }
  
  allTime = players[0];
  currentBest = players[0];
 }
 
  Population(int size, int dim, int snakeLength) {
 
  bestLen = snakeLength; 
   
  players = new Player[size];
  for(int i = 0; i < size; i++) {
   players[i] = new Player(height,height/dim,snakeLength);
  }

  allTime = players[0];
  currentBest = players[0];
 }
 
 void show(boolean showAll) {
  if(showAll) {
    for(int i = 0; i < players.length; i++) {
       players[i].show();
    }
  } else {
    players[0].show(); 
  }
 }
 
 void update(float rate) {   
   
  if(players[0].dead()) {
    deaths++;
    players[0].calculateFitness();
    fitnessSum -= players[0].fitness();
    players[0] = allTime.clone();  
  }
  
  if(players[1].dead()) {
    deaths++;
    players[1].calculateFitness();
    fitnessSum -= players[1].fitness();
    players[1] = currentBest.clone();
  }
  
  for(int i = 0; i < players.length; i++) {
    int max = 0;
    
   if(!players[i].dead()) {
     if(players[i].len() > max) {
       if(players[i].len() > bestLen) {
         bestLen = players[i].len();
         allTime = players[i];
       }
       currentBest = players[i];
       max = currentBest.len();
     }
     
     fitnessSum -= players[i].fitness();
     players[i].move();
     fitnessSum += players[i].fitness();
   } else {
     deaths++;
     players[i].calculateFitness();
     double fit = players[i].fitness();
     fitnessSum -= fit;
     
     
     if(fit > bestFitAll) {
       bestFitAll = fit; 
       bestLen = players[i].len();
     }
     
     Player parent1 = selectParent();
     Player parent2 = selectParent();
     
     players[i] = parent1.breedWith(parent2);
     players[i].mutate(rate);
   }
  }
 }
 
 int deaths() {
  return deaths; 
 }
 
 Player selectParent() {
   float rand = random(fitnessSum); //<>// //<>//
   
   float runningsum = 0;
   for(int i = 0; i < players.length; i++) {
     runningsum += players[i].fitness(); 
     if (runningsum > rand) {
      return players[i]; 
     }
   }
   
   return players[0];
 }
 
  public int bestLength() {
  return bestLen; 
 }
 
 public int bestCurLength() {
  int max = 0;
  
  for(int i = 0; i < players.length; i++) {
   if(players[i].len() > max) {
     max = players[i].len();
   }
  }
  
  return max;
 }
 
  public int bestColor() {
  int max = 0;
  Player p = players[0];;
  
  for(int i = 0; i < players.length; i++) {
   if(players[i].len() > max) {
     max = players[i].len();
     p = players[i];
   }
  }
  
  return p.marker();
 }
 
 public Player currentBest() {
  return currentBest; 
 }
 
 public Player playerOne() {
  return players[0]; 
 }
 
 public float average() {
   float acc = 0;
  for(int i = 2; i < players.length; i++) {
   acc += players[i].len(); 
  } 
  return acc/ (float)players.length;
 }
 
  public int averageColor() {
  int r = 0;
  int g = 0;
  int b = 0;
  int num = players.length;
  
  for(int i = 0; i < num; i++) {
      color c = players[i].marker();
      r += red(c) * red(c);
      g += green(c) * green(c);
      b += blue(c) * blue(c);
    }

  return color(sqrt(r/num), sqrt(g/num), sqrt(b/num));
 }
 
}
