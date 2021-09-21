import controlP5.*;
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
int x;
int y;
String[] shapeTypes = new String[]{"SQUARES", "HEXAGONS"};

void setup(){
  cp5 = new ControlP5(this);       
  size(1200, 800);
  x = width/2;
  y = height/2;
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
    println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
  }
}

public void start(int value){
  println(shapes.getValue());
}
