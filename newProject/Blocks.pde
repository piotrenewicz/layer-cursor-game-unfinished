class Block{
  int x;
  int y;
  int ID;
  
 
  
  void SetAttribs(String attribs[][]){
    for(String value[] : attribs){
      switch(switchUtil(value[0], new String[]{
        "x", //0
        "y"  //1
      })){
        case 0:
          x=int(value[1]);
          break;
        case 1:
          y=int(value[1]);
          break;
      }
    }
  }
  
  void MU(){};
  void GU(){};
  void DE(){}; //as in destroy
  void CR(){}; //as in create  this stuff will act as accessors to our childs.
  
}



  // here will be the code that implements attribs, more classes will extend this class for a library of blocks.

class Plane extends Block{
  int x2=5;
  int y2=5;
  
  int transparency=0;
  int R=255;
  int G=255;
  int B=255;
  color c= color(R,G,B);
  
  Plane(String attribs[][]){
    SetAttribs(attribs);
    ID = 1;
  }
  
  void SetAttribs(String attribs[][]){//this overload will be the thing that is supposed to be run and will implement attribs;
    for(String value[] : attribs){
      switch(switchUtil(value[0], new String[]{
        "x2", //0
        "y2", //1
        "T" , //2
        "R" , //3
        "G" , //4
        "B" , //5
        "C"   //6
       
      })){
        case 0:
          x2=int(value[1]);
          break;
        case 1:
          y2=int(value[1]);
          break;
        case 2:
          transparency=int(value[1]);
          break;
        case 3:
          R=int(value[1]);
          c=color(R,G,B);
          break;
        case 4:
          G=int(value[1]);
          c=color(R,G,B);
          break;
        case 5:
          B=int(value[1]);
          c=color(R,G,B);
          break;
        case 6:
          R=int(value[1]);
          G=int(value[2]);
          B=int(value[3]);
          c=color(R, G, B);
          break;
      }
    }
    super.SetAttribs(attribs);
  }
  
  PMatrix2D storage;
  
  void MU(){
    storage = getMatrix(storage);
  }
  
  void GU(){
    //println("I'm trying to run properly");
    pushMatrix();
    applyMatrix(storage);
      fill(c);
      rect(0,0, x2, y2);    //here we will draw the block
    popMatrix();
  }
}

class Door extends Block{
  Door(String attribs[][]){
  }
}

class Spawn extends Block{
  Spawn(String attribs[][]){
  }
}

class LayerHolder extends Block{
  int l;
  Body Holder;
  
  void DE(){
    box2d.destroyBody(Holder);
  }
  
  LayerHolder(String attribs[][]){
    SetAttribs(attribs);
  }
  
  void SetAttribs(String attribs[][]){//LOOK for l;
    for(String value[] : attribs){
      switch(switchUtil(value[0], new String[]{
      "l" //0
      })){
        case 0:
          l=int(value[1]);
          break;
        
      }
    }
    mM.stages[mM.currentStage].addLayer(l);
    print(l);
    super.SetAttribs(attribs);
  }
  
  void MU(){
    BodyDef HolderDef = new BodyDef();
    HolderDef.type = BodyType.DYNAMIC;
    Vec2 spawn = new Vec2(screenX(0,0),screenY(0,0));
    HolderDef.position.set(box2d.coordPixelsToWorld(spawn));
    
    mM.stages[mM.currentStage].layers.get(l).MU();   //whoah complex,,   mapManager. from all the stages, choose the currentStage, and from layers in that stage .get the one I'm hosting (l), and tell it to MachineUpdate();
  }
}

class Slider extends LayerHolder{
  int x2=5;
  int y2=5;
  
  float f=0;
  boolean s = false;
  float p= 25;
  
  Slider(String attribs[][]){
    super(attribs);
    super.SetAttribs(attribs);
    SetAttribs(attribs);
    ID = 5;
  }
  
  void SetAttribs(String attribs[][]){
    for(String value[] : attribs){
      switch(switchUtil(value[0], new String[]{
        "x2", //0
        "y2", //1
        "f" , //2
        "s" , //3
        "%"   //4
      
      })){
        case 0:
          x2=int(value[1]);
          break;
        case 1:
          y2=int(value[1]);
          break;
        case 2:
          f=float(value[1]);
          break;
        case 3:
          s=boolean(int(value[1]));
          break;
        case 4:
          p=int(value[1]);
          break;
        
      }
    }
  }
  
  void MU(){
    p+=f;
    if(p==100)p=0;
    float cx = map(p, 0, 100, x, x2);
    float cy = map(p, 0, 100, y, y2);//just testing if translate can take floats
    translate(cx, cy);
    super.MU();
  }
}

class Rotor extends LayerHolder{
  float f=0;
  boolean s = false;
  float p= 25;
  
  Rotor(String attribs[][]){
    super(attribs);
    super.SetAttribs(attribs);
    SetAttribs(attribs);
    ID = 6;
  }
  
  void SetAttribs(String attribs[][]){
    for(String value[] : attribs){
      switch(switchUtil(value[0], new String[]{
        "f", //0
        "s", //1
        "%"  //2
      
      })){
        case 0:
          f=float(value[1]);
          break;
        case 1:
          s=boolean(int(value[1]));
          break;
        case 2:
          p=int(value[1]);
          break;
      }
    }
  }
  
  void MU(){
    p+=f;
    if(p==100)p=0;
    float cp = map(p, 0, 100, 0, 360);
    rotate(radians(cp));
    super.MU();
  }
  
}

/*class Plane extends Block{
  Plane(String attribs[][]){
  }
}

*/

//i dunno how to do this, i need a way to map classes to numbers

//class B1 extends Block{
  //blockID=1;
  //B1(){
  //}
//}