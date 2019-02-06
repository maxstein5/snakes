class Network {
  private float[][] output;
  private float[][][] weights;
  private float[][] bias;
  
  public final int[] NETWORK_LAYER_SIZES;
  public final int INPUT_SIZE;
  public final int OUTPUT_SIZE;
  public final int NETWORK_SIZE;
  
  
  public Network(int... NETWORK_LAYER_SIZES) {
    this.NETWORK_LAYER_SIZES = NETWORK_LAYER_SIZES;
    this.INPUT_SIZE = NETWORK_LAYER_SIZES[0];
    this.NETWORK_SIZE = NETWORK_LAYER_SIZES.length;
    this.OUTPUT_SIZE = NETWORK_SIZE;

    output = new float[NETWORK_SIZE][];
    weights = new float[NETWORK_SIZE][][];
    bias = new float[NETWORK_SIZE][];
    
    for(int i = 0; i < NETWORK_SIZE; i++) {
      output[i] = new float[NETWORK_LAYER_SIZES[i]];
      bias[i] = randomArray(NETWORK_LAYER_SIZES[i],1);
      
      if(i > 0) {
        weights[i] = randomArray(NETWORK_LAYER_SIZES[i],NETWORK_LAYER_SIZES[i-1],1);
      }
    }
  }

  public float[] calculate(float... input) {
    if(!((float)input.length == NETWORK_LAYER_SIZES[0])) return null;
    this.output[0] = input;
    for(int layer = 1; layer < NETWORK_SIZE; layer++) {
      for(int neuron = 0; neuron < NETWORK_LAYER_SIZES[layer]; neuron++) {
        float sum = bias[layer][neuron];
        for(int prevNeuron = 0; prevNeuron < NETWORK_LAYER_SIZES[layer-1]; prevNeuron++) {
          sum += output[layer-1][prevNeuron] * weights[layer][neuron][prevNeuron];  
        }
        output[layer][neuron] = activation(sum);
      }
    }
    
    return output[NETWORK_SIZE-1];
  }
  
  //-------------------------------------------------------------------------
  
  private float activation(float x) {
   //return 1f / (1 + exp(-x));
   return atan(x);
  }
  
  
  private float[] randomArray(int length, float prob) {
     float [] arr = new float[length];
     
     for(int i = 0; i < length; i++){
       float rand = random(0,1);
       if(rand < prob) {
         arr[i] =  randomGaussian()/5;
         if (arr[i] > 1) arr[i] = 1;
         if (arr[i] < -1) arr[i] = -1;
       }   
     }
     
     return arr;
  }
  
    private float[][] randomArray(int lengthX, int lengthY, float prob) {
     float [][] arr = new float[lengthX][lengthY];
     
     for(int i = 0; i < lengthX; i++){
       for(int j = 0; j < lengthY; j++) {
         float rand = random(0,1);
         if(rand < prob) {
           arr[i][j] = randomGaussian()/5;
           if (arr[i][j] > 1) arr[i][j] = 1;
           if (arr[i][j] < -1) arr[i][j] = -1;
         }
       }
     }   
     
     return arr;
  }
  
  private float[] mutateArray(float[] array, float prob) { 
     float [] arr = new float[array.length];

     for(int i = 0; i < arr.length; i++){
         arr[i] = array[i];
     }
    
     for(int i = 0; i < arr.length; i++){
         float rand = random(0,1);
         if(rand < prob) {
           arr[i] += randomGaussian()/10;
           if (arr[i] > 1) arr[i] = 1;
           if (arr[i] < -1) arr[i] = -1;
       }
     }   
     return arr;
  }
  
  private float[][] mutateArray(float[][] array, float prob) {
     float [][] arr = new float[array.length][array[0].length];

     for(int i = 0; i < arr.length; i++){
       for(int j = 0; j < arr[0].length; j++) {
         arr[i][j] = array[i][j];
       }
     }
         
         
     for(int i = 0; i < arr.length; i++){
       for(int j = 0; j < arr[0].length; j++) {
         float rand = random(0,1);
         if(rand < prob) {
           arr[i][j] += randomGaussian()/10;
           if (arr[i][j] > 1) arr[i][j] = 1;
           if (arr[i][j] < -1) arr[i][j] = -1;
         }
       }
     }   
     return arr;
  }
  
  public void netSetup(float[][][] newWeights, float[][] newBias) {
      for(int i = 0; i < NETWORK_SIZE; i++) {
      bias[i] = newBias[i];
      
      if(i > 0) {
        weights[i] = newWeights[i];
      }
    }
  }
  
  
  //------------------------------------------------------------------------- evolution methods
  
  public Network clone(int max) {
    Network clone = new Network(NETWORK_LAYER_SIZES);
    clone.netSetup(weights, bias);
    return clone;
  }
  
  public void mutate(float rate) {
        for(int i = 0; i < NETWORK_SIZE; i++) {
          bias[i] = mutateArray(bias[i],rate);
          if(i > 0) {
            weights[i] = mutateArray(weights[i],rate); 
          }
        }
    
  }
  
  public int step(float... input) { 
    float[] calc = calculate(input);
    float maxVal = 0;
    int maxInd = 0;
    
    for(int i = 0; i < calc.length; i++) {
      if(calc[i] > maxVal) {
        maxVal = calc[i];
        maxInd = i;
      }
    }
    return (maxInd+1);
  }
  
  public Network combineWith(Network parent) {
    Network child = this.clone(1);
    Network otherHalf = parent.clone(1);
    
    float[][][] weights1 = child.weights();
    float[][][] weights2 = otherHalf.weights();
    float[][] bias1 = child.bias();
    float[][] bias2 = otherHalf.bias();
    
    for(int i = 0; i < NETWORK_SIZE; i++) {
      float rand = random(0,1);
      if(rand < 0.5) {
        weights1[i] = weights2[i];
      
        if(i > 0) {
          bias1[i] = bias2[i];
        }
      }
    }
    
    child.netSetup(weights1, bias1);
    return child;
  }
  
//-----------------------------------------------------------------------------

public float[][][] weights() {
 return weights; 
}

public float[][] bias() {
 return bias; 
}
  
//----------------------------------------------------------------------------- visualization

public void show(int xpos, int ypos, int w, int h) {
    fill(0);
    stroke(255);
    rect(xpos,ypos,w,h);
    xpos = xpos + 5;
    ypos = ypos + 5;
    w = w-10;
    h = h-10;
    ellipseMode(CORNER);
    int xBlock = w/NETWORK_SIZE; 
    int yBlock = h/max(NETWORK_LAYER_SIZES);
    int prevOffset = 0;
  
    for(int layer = 0; layer < NETWORK_SIZE; layer++) {
      int offset = (max(NETWORK_LAYER_SIZES) - NETWORK_LAYER_SIZES[layer])/2;
      for(int neuron = 0; neuron < NETWORK_LAYER_SIZES[layer]; neuron++){
        color outputCol = color(127+127f*output[layer][neuron],0,127-127f*output[layer][neuron]);
        fill(outputCol);
        strokeWeight(3);
        stroke(225/2 + bias[layer][neuron]*255/2);
        ellipse(xpos + layer*xBlock + xBlock/4, ypos + (neuron+offset)*yBlock,yBlock-3,yBlock-3);
        fill(255);
        
        if(layer > 0) {
          for(int prevNeuron = 0; prevNeuron < NETWORK_LAYER_SIZES[layer-1]; prevNeuron++) {
            float oneWeight = weights[layer][neuron][prevNeuron];
            
            strokeWeight(3*abs(oneWeight));
            outputCol = color(127 + 127f*output[layer-1][prevNeuron]*oneWeight,0,127-127f*output[layer-1][prevNeuron]*oneWeight);
            stroke(outputCol);
            line(xpos + (layer-1)*xBlock + yBlock + xBlock/4, ypos + (prevNeuron + prevOffset)*yBlock + (yBlock/2), xpos + layer*xBlock + xBlock/4, ypos + (neuron+offset)*yBlock + (yBlock/2));
            strokeWeight(1);
            stroke(0);
          }
        }
        textSize(12);
        text(nf(round(100*output[layer][neuron])/100f,0,2) ,xpos + layer*xBlock + xBlock/4, ypos + (neuron+offset)*yBlock + yBlock/2);
     } 
     prevOffset = offset;
    } 
   stroke(0);
}

//----------------------------------------------------------------------------- saving to table

public void saveToCSV(String filePath) {
  Table table = new Table();
  
  for(int i = 0; i < max(NETWORK_LAYER_SIZES); i++) {
   table.addColumn(); 
  }
  
  table.addRow();
  int row = 0;
  
  for(int i = 0; i < NETWORK_SIZE; i++) {
   table.setInt(row,i,NETWORK_LAYER_SIZES[i]); 
  }
  
  
  for(int layer = 0; layer < NETWORK_SIZE; layer++) {
    table.addRow();
    row++;
    for(int neuron = 0; neuron < NETWORK_LAYER_SIZES[layer]; neuron++) {
      table.setFloat(row,neuron,bias[layer][neuron]);
    }
  }
  
  for(int layer = 1; layer < NETWORK_SIZE; layer++) {
    for(int neuron = 0; neuron < NETWORK_LAYER_SIZES[layer]; neuron++) {
        table.addRow();
        row++;
        for(int prevNeuron = 0; prevNeuron < NETWORK_LAYER_SIZES[layer-1]; prevNeuron++) {
          table.setFloat(row,prevNeuron,weights[layer][neuron][prevNeuron]);
        }
      }
    }
  
  saveTable(table, "data/" + filePath + ".csv");
}

public Network readFromCSV(String filePath) {
  Table table = loadTable("data/" + filePath + ".csv");
  
  int row = 0;
  int col = 0;
  IntList NLSList = new IntList();
  
  while(table.getInt(row,col) != 0) {
    NLSList.append(table.getInt(row,col));
    col++;
  }
  
  int NS = NLSList.size();
  int[] NLS = NLSList.array();
  Network net = new Network(NLS);

  float[][][] w = new float[NS][][];
  float[][] b = new float[NS][];
    
  for(int i = 0; i < NS; i++) {
      b[i] = new float[NLS[i]];
      
      if(i > 0) {
        w[i] = new float[NLS[i]][NLS[i-1]];
      }
  }
  
  for(int layer = 0; layer < NS; layer++) {
    row++;
    for(int neuron = 0; neuron < NLS[layer]; neuron++) {
      b[layer][neuron] = table.getFloat(row,neuron); 
    }
  }
  
  for(int layer = 1; layer < NS; layer++) {
    for(int neuron = 0; neuron < NLS[layer]; neuron++) {
        row++;
        for(int prevNeuron = 0; prevNeuron < NLS[layer-1]; prevNeuron++) {
          w[layer][neuron][prevNeuron] = table.getFloat(row,prevNeuron);
        }
     }
  }
  net.netSetup(w,b);
  return net;
}
   
}
