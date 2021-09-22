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
  float stepScale;
  int minHor;
  int minVert;
  int maxHor;
  int maxVert;
  int currX;
  int currY;
  boolean useColor;
  boolean useStroke;
  HashMap<PVector, Integer> visited; 
  RandomWalk(int numSteps, int stepDistance, float stepScale, int minHor, int minVert, int maxHor, int maxVert, boolean useColor, boolean useStroke){
    this.numSteps = numSteps;
    this.stepsTaken = 0;
    this.stepDistance = stepDistance;
    this.stepScale = stepScale;
    this.minHor = minHor;
    this.minVert = minVert;
    this.maxHor = maxHor;
    this.maxVert = maxVert;
    this.currX = maxHor/2;
    this.currY = maxVert/2;
    this.useColor = useColor;
    this.useStroke = useStroke;
  }
  abstract void Update();
  abstract void Draw(int direction);
}

class SquareWalk extends RandomWalk {
  
  SquareWalk(int numSteps, int stepDistance, float stepScale, int minHor, int minVert, int maxHor, int maxVert, boolean useColor, boolean useStroke){
    super(numSteps,stepDistance,stepScale,minHor, minVert, maxHor, maxVert, useColor,useStroke);
  }
  
  void Draw(int direction){
    fill(167,100,200);
    square(currX, currY, stepDistance*stepScale);
    int returnVal = visited.putIfAbsent(new PVector(currX, currY), 0);
    if(returnVal != 0)
       visited.put(new PVector(currX, currY), returnVal+1);
  }
  
  void Update(){
    boolean pickDirection = true;
    int direction = 0;
    while(pickDirection){
      direction = int(random(0,4));
      switch (direction){
        case 0:
          if(currY + this.stepDistance*stepScale < height){
             currY += this.stepDistance*stepScale;
             pickDirection = false;
          }
        break;
        case 2: 
          if(currY - this.stepDistance*stepScale  > 0){ 
            currY -= this.stepDistance*stepScale;
            pickDirection = false;
         }
         break;
        case 1: 
          if(currX + this.stepDistance*stepScale  < width){
            currX += this.stepDistance*stepScale;
           pickDirection = false;
          }
         break;
      case 3: 
        if(currX - this.stepDistance*stepScale  > 0){
           currX -= this.stepDistance*stepScale;
           pickDirection = false;
        }
        break;
      }
    }
    this.Draw(direction);
  }
  
 
}

class HexWalk extends RandomWalk {
  
  HexWalk(int numSteps, int stepDistance, float stepScale, int minHor, int minVert, int maxHor, int maxVert, boolean useColor, boolean useStroke){
    super(numSteps,stepDistance,stepScale, minHor, minVert, maxHor,maxVert, useColor,useStroke);
  }
  
  void Draw(int direction){
     
    
  }
    
  
  void Update(){
    
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
  rect(0,0,200, 800);
  if(start){
    
  }
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
  println(shapes.getValue());
  start = true;
}
