import controlP5.*;
boolean start = false;
ControlP5 cp5;
DropdownList shapes;
Slider step;
Slider iterations;
Slider size; 
Slider scale;
Toggle constrain; 
Toggle terrain;
Toggle useStroke;
Toggle useRandomSeed;
Textfield seedValue;
RandomWalk path = null;
String[] shapeTypes = new String[]{"SQUARES", "HEXAGONS"};


abstract class RandomWalk {
  int numSteps;
  int stepsTaken;
  int stepDistance;
  public int stepRate = 1;
  float stepScale;
  int minHor;
  int minVert;
  int maxHor;
  int maxVert;
  float currX;
  float currY;
  boolean constrain;
  boolean terrain;
  boolean useStroke;
  HashMap<PVector, Integer> visited = new HashMap<PVector, Integer>(); 
  RandomWalk(int numSteps, int stepDistance, float stepScale, int minHor, int minVert, int maxHor, int maxVert,boolean constrain, boolean terrain,boolean useStroke){
    
    this.numSteps = numSteps;
    this.stepsTaken = 0;
    this.stepDistance = stepDistance;
    this.stepScale = stepScale;
    this.minHor = minHor;
    this.minVert = minVert;
    this.maxHor = maxHor;
    this.maxVert = maxVert;
    this.currX = maxHor/2 + minHor/2;
    this.currY = maxVert/2;
    this.constrain = constrain;
    this.terrain = terrain;
    this.useStroke = useStroke;
  }
  abstract void Update();
  abstract void Draw(int direction);
}

class SquareWalk extends RandomWalk {
  
  SquareWalk(int numSteps, int stepDistance, float stepScale, int minHor, int minVert, int maxHor, int maxVert, boolean constrain,  boolean terrain,  boolean useStroke){
    super(numSteps,stepDistance,stepScale,minHor, minVert, maxHor, maxVert, constrain,  terrain, useStroke);
  } 
  
  //needs to change to comply with
  //simulate terrain
  //use stroke (draw outline)
  void Draw(int direction){
    rectMode(CENTER);
    if(!terrain){
      fill(167,100,200);
    }
    else{
      int timesVisited = visited.getOrDefault(new PVector(currX, currY), 0);
      //println(timesVisited);
      if(timesVisited < 4){
         fill(160,126,84);
      }
      else if(timesVisited < 7){
         fill(143,170,64);
      }
      else if(timesVisited < 10){
         fill(135,135,135);
      }
      else {
         fill(timesVisited*20);
      }
    }
    if(!useStroke){
      noStroke();
    }
    else {
      stroke(0);
    }
    square(currX, currY, int(stepDistance*stepScale));
    switch (direction){
            case 0:
                 currY += this.stepDistance*stepScale;
              break;
            case 2: 
                currY -= this.stepDistance*stepScale;
             break;
            case 1: 
                currX += this.stepDistance*stepScale;
             break;
          case 3: 
               currX -= this.stepDistance*stepScale;
            break;
          } 
    if(visited.putIfAbsent(new PVector(currX, currY), 0) != null){
        visited.put(new PVector(currX, currY), visited.get(new PVector(currX, currY))+1);
    }
    stepsTaken++;
  }
  
  
  void Update(){
    for(int i =0; i < stepRate; i++){
      boolean pickDirection = true;
       int direction = int(random(0,4));
        while(pickDirection){
      direction = int(random(0,4));
      //change this
          switch (direction){
            case 0:
              if(currY + this.stepDistance*1.5 < height || (!constrain) ){
                 pickDirection = false;
              }
            break;
            case 2: 
              if(currY - this.stepDistance*1.5  > minVert ||(!constrain) ){ 
                pickDirection = false;
             }
             break;
            case 1: 
              if(currX + this.stepDistance*1.5  < width ||(!constrain) ){
               pickDirection = false;
              }
             break;
          case 3: 
            if(currX - this.stepDistance*1.5 > minHor ||(!constrain) ){
               pickDirection = false;
            }
            break;
          }
        }
    this.Draw(direction);
     if(stepsTaken >= numSteps){
       break;
      }
      
    //println(stepsTaken, numSteps);
   }
  
    
  }
 
}

class HexWalk extends RandomWalk {
  
  float xOrigin;
  float yOrigin;
  PVector north; 
  PVector northEast;
  PVector southEast;
  PVector south;
  PVector southWest;
  PVector northWest;
  
  HexWalk(int numSteps, int stepDistance, float stepScale, int minHor, int minVert, int maxHor, int maxVert,  boolean constrain, boolean terrain, boolean useStroke){
    super(numSteps,stepDistance,stepScale, minHor, minVert, maxHor,maxVert,  constrain, terrain,useStroke);
    float xTmp = (1.5)*stepDistance;
    float yTmp = stepDistance*(sqrt(3)/2);
    float nsTmp = sqrt(3)*stepDistance;
    //standardized values for drawing hexagons
    north = new PVector(0,-nsTmp);
    south = new PVector(0,nsTmp);
    northEast = new PVector(xTmp,-yTmp);
    southEast = new PVector(xTmp,yTmp);
    southWest = new PVector(-xTmp,yTmp);
    northWest = new PVector(-xTmp,-yTmp);
    xOrigin = currX;
    yOrigin = currY;
  }
  
  PVector CartesianToHex(float xPos, float yPos, float hexRadius, float stepScale, float xOrigin, float yOrigin)
  {
    float startX = xPos - xOrigin;
    float startY = yPos - yOrigin;
  
    float col = (2.0/3.0f * startX) / (hexRadius * stepScale);
    float row = (-1.0f/3.0f * startX + 1/sqrt(3.0f) * startY) / (hexRadius * stepScale);
    
    /*===== Convert to Cube Coordinates =====*/
    float x = col;
    float z = row;
    float y = -x - z; // x + y + z = 0 in this system
    
    float roundX = round(x);
    float roundY = round(y);
    float roundZ = round(z);
    
    float xDiff = abs(roundX - x);
    float yDiff = abs(roundY - y);
    float zDiff = abs(roundZ - z);
    
    if (xDiff > yDiff && xDiff > zDiff)
      roundX = -roundY - roundZ;
    else if (yDiff > zDiff)
      roundY = -roundX - roundZ;
    else
      roundZ = -roundX - roundY;
      
    /*===== Convert Cube to Axial Coordinates =====*/
    PVector result = new PVector(roundX, roundZ);
    return result;
  }
  
  void Draw(int direction){
    
    
      PVector tmp = CartesianToHex(currX, currY, stepDistance, stepScale, xOrigin, yOrigin);
      if(!terrain){
        fill(167,100,200);
      }
      else{
        int timesVisited = visited.getOrDefault(tmp, 0);
        //println(timesVisited);
        if(timesVisited < 4){
           fill(160,126,84);
        }
        else if(timesVisited < 7){
           fill(143,170,64);
        }
        else if(timesVisited < 10){
           fill(135,135,135);
        }
        else {
           fill(timesVisited*20);
        }
      }  
      
      if(!useStroke){
        noStroke();
      }
      else {
        stroke(0);
      }
      beginShape();
      for (int i = 0; i <= 360; i+= 60)
      {
        float xPos = currX + cos(radians(i)) * stepDistance;
        float yPos = currY + sin(radians(i)) * stepDistance;
    
        vertex(xPos, yPos);
      }
     
      endShape();
      if(visited.putIfAbsent(tmp, 0) != null){
        visited.put(tmp, visited.get(tmp)+1);
      }
      switch (direction){
        case 0 : 
          currY += southEast.y;
          currX += southEast.x;
          break;
          
        case 1 :
          currY += south.y;
          currX += south.x;
          break;
          
        case 2 :
          currY += southWest.y;
          currX += southWest.x;
          break;
          
        case 3 :
          currY += northWest.y;
          currX += northWest.x;
          break;
          
        case 4 :
          currY += north.y;
          currX += north.x;
          break;
          
        case 5 :
          currY += northEast.y;
          currX += northEast.x;
          break;
      }
      stepsTaken++;
     
  }
    
  
   void Update(){
     for(int i =0; i < stepRate; i++){
      boolean pickDirection = true;
       
      int direction = int(random(0,6));
      while(pickDirection){
        direction =  int(random(0,6));
        //change this
            switch (direction){
              case 0:
                if(((currY + southEast.y*1.5) < maxVert && (currX + southEast.x*1.5)  < maxHor )|| (!constrain) ){
                   pickDirection = false;
                }
              break;
              case 1: 
                if(((currY + south.y*1.5)  < maxVert) ||(!constrain) ){ 
                  pickDirection = false;
                }
               break;
              case 2: 
                if(((currY + southWest.y*1.5) < maxVert && (currX + southWest.x*1.5 ) > minHor)||(!constrain) ){
                   pickDirection = false;
                }
               break;
            case 3: 
                if(((currY + northWest.y*1.5)  > minVert && (currX+northWest.x*1.5)  > minHor)||(!constrain) ){
                   pickDirection = false;
                }
              break;
            case 4: 
                if(((currY + north.y*1.5)  > minVert)||(!constrain) ){
                   pickDirection = false;
                }
              break;
            case 5:
                if(((currY + northEast.y*1.5 ) > minVert && (currX + northEast.x*1.5)  < maxHor)||(!constrain) ){
                   pickDirection = false;
                }
              break;
            }
          }
     this.Draw(direction);
     if(stepsTaken >= numSteps){
       break;
     }
    //println(stepsTaken, numSteps);
   }
  }
    
  
  
 
}

void setup(){
  cp5 = new ControlP5(this);       
  size(1200, 800);
  cp5.addButton("start")
       .setValue(0)
      .setPosition(20,20)
      .setSize(100,40)
      .setColorBackground(color(0,150,0));
      
       shapes = cp5.addDropdownList("shapes")
              .setPosition(20,70)
              .setSize(150,120)
              .addItems(shapeTypes)
              .setBarHeight(40)
              .setItemHeight(40);
              
      
   Textlabel iterationsLabel = cp5.addTextlabel("iterationsLabel")
                                 .setText("Maximum Steps")
                                 .setPosition(20,210)
                                 .setColorValue(0xffffffff)
                                 .setFont(createFont("Georgia",15));
 
  
  iterations = cp5.addSlider("iterations")
                            .setMin(100)
                            .setMax(50000)
                            .setPosition(20,230)
                            .setHeight(30)
                            .setWidth(160)
                            .setValue(100)
                            .setCaptionLabel("");
                            
  Textlabel stepLabel = cp5.addTextlabel("stepLabel")
                                 .setText("Step Rate")
                                 .setPosition(20,270)
                                 .setColorValue(0xffffffff)
                                 .setFont(createFont("Georgia",15));                          
              
  step = cp5.addSlider("step")
                        .setMin(1)
                        .setMax(1000)
                        .setPosition(20, 290)
                        .setHeight(30)
                        .setWidth(160)
                        .setCaptionLabel("");
                        
  Textlabel sizeLabel = cp5.addTextlabel("sizeLabel")
                                 .setText("Step Size")
                                 .setPosition(20,330)
                                 .setColorValue(0xffffffff)
                                 .setFont(createFont("Georgia",15));                        
  
  size = cp5.addSlider("size")
                            .setMin(10)
                            .setMax(30)
                            .setPosition(20,350)
                            .setHeight(30)
                            .setWidth(80)
                            .setCaptionLabel("");
                            
  Textlabel scaleLabel = cp5.addTextlabel("scaleLabel")
                                 .setText("Step Scale")
                                 .setPosition(20,390)
                                 .setColorValue(0xffffffff)
                                 .setFont(createFont("Georgia",15));                            
                            
  scale = cp5.addSlider("scale")
                            .setMin(1)
                            .setMax(1.5)
                            .setPosition(20,410)
                            .setHeight(30)
                            .setWidth(80)
                            .setCaptionLabel("");       
  
  constrain = cp5.addToggle("constrain steps")
                 .setPosition(20, 450)
                 .setSize(30,30); 
  
  terrain = cp5.addToggle("simulate terrain")
                 .setPosition(20, 510)
                 .setSize(30,30);   
  
  useStroke = cp5.addToggle("use stroke")
                 .setPosition(20, 570)
                 .setSize(30,30); 
                 
  useRandomSeed = cp5.addToggle("use random seed")
                 .setPosition(20, 630)
                 .setSize(30,30);   
                 
  seedValue = cp5.addTextfield("seed value")
              .setPosition(100, 630)
              .setSize(80, 30)
              .setValue("0")
              .setInputFilter(cp5.INTEGER);
}

void draw() {
   fill(153);
  rectMode(CORNER);
  rect(0,0,200, 800);
  if(start){  
    if(path.stepsTaken < path.numSteps){
      path.Update();
    }
  }
  
   fill(153);
  rectMode(CORNER);
  rect(0,0,200, 800);
}

void controlEvent(ControlEvent theEvent) {
  // DropdownList is of type ControlGroup.
  // A controlEvent will be triggered from inside the ControlGroup class.
  // therefore you need to check the originator of the Event with
  // if (theEvent.isGroup())
  // to avoid an error message thrown by controlP5.

  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
  } 
  else if (theEvent.isController()) {
    println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController().getLabel());
  }
}

public void start(int value){
  
  //TODO add in controller values and assigning them to the path object value
  //seed random value with the random thing
  //numSteps,stepDistance,stepScale,minHor, minVert, maxHor, maxVert, constrain,terrain,useStroke
  smooth();
    background(96,171,216);
    fill(153);
  rectMode(CORNER);
  rect(0,0,200, 800);
  if(useRandomSeed.getState()){
   randomSeed(int(seedValue.getText()));
  }
 if(shapes.getValue() == 0){
    path = new SquareWalk(int(iterations.getValue()), int(size.getValue()), scale.getValue(), 200, 0, width, height, constrain.getState(), terrain.getState(), useStroke.getState());
 }
 else if(shapes.getValue() == 1) {
    path = new HexWalk(int(iterations.getValue()), int(size.getValue()), scale.getValue(), 200, 0, width, height, constrain.getState(), terrain.getState(), useStroke.getState());
 }
 path.stepRate = int(step.getValue());
  start = true;
}

public void iterations(int num){
}
public void step(int num){
  path.stepRate = num;
}

public void size(int num){
}

public void scale(float num){
}
