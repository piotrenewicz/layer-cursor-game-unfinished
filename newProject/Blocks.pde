class Block{
  int x;
  int y;
  int ID;
  
 
  
  void SetAttribs(String attribs[][]){
    for(String value[] : attribs){
      switch(value[0]){
        case "x":
          x=int(value[1]);
          break;
        case "y":
          y=int(value[1]);
          break;
      }
    }
  }
  
  void MU(){};
  void GU(){};
  void DE(){}; //as in destroy
  void CR(){}; //as in create  this stuff will act as accessors to our childs.
  int AU(){return 0;} //authentication access and fail.
  
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
      switch(value[0]){
        case "x2":
          x2=int(value[1]);
          break;
        case "y2":
          y2=int(value[1]);
          break;
        case "T":
          transparency=int(value[1]);
          break;
        case "R":
          R=int(value[1]);
          c=color(R,G,B);
          break;
        case "G":
          G=int(value[1]);
          c=color(R,G,B);
          break;
        case "B":
          B=int(value[1]);
          c=color(R,G,B);
          break;
        case "C":
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
  WeldJoint LWeld;
  
  
  
  LayerHolder(String attribs[][]){
    SetAttribs(attribs);
  }
  
  void SetAttribs(String attribs[][]){//LOOK for l;
    for(String value[] : attribs){
      switch(value[0]){
        case "l":
          l=int(value[1]);
          break;
        
      }
    }
    mM.stages[mM.currentStage].addLayer(l);
    print(l);
    super.SetAttribs(attribs);
  }
  
  int AU(){return 1;}  //authenticate as a body having entity
  
  void MU(){
    mM.stages[mM.currentStage].layers.get(l).MU();   //whoah complex,,   mapManager. from all the stages, choose the currentStage, and from layers in that stage .get the one I'm hosting (l), and tell it to MachineUpdate();
  }
  
  void CR(){
    BodyDef HolderDef = new BodyDef();
    HolderDef.type = BodyType.DYNAMIC;
    Vec2 spawn = new Vec2(screenX(0,0),screenY(0,0));
    HolderDef.position.set(box2d.coordPixelsToWorld(spawn));
    Holder = box2d.createBody(HolderDef);
    
    mM.stages[mM.currentStage].layers.get(l).CR();   //whoah complex,,   mapManager. from all the stages, choose the currentStage, and from layers in that stage .get the one I'm hosting (l), and tell it to MachineUpdate();
    
    WeldJointDef layerWeld = new WeldJointDef();
    layerWeld.bodyA = Holder;
    layerWeld.bodyB = mM.stages[mM.currentStage].layers.get(l).Layer;
    layerWeld.dampingRatio = 1;
    layerWeld.frequencyHz = 0;
    layerWeld.localAnchorA.set(new Vec2(0,0));
    
    LWeld = (WeldJoint) box2d.world.createJoint(layerWeld);
    //weld joint definition here
  }
  
  void DE(){
    //destroy the weld
    LWeld.destroy(LWeld);
    
    mM.stages[mM.currentStage].layers.get(l).DE();
    
    box2d.destroyBody(Holder);
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
      switch(value[0]){
        case "x2":
          x2=int(value[1]);
          break;
        case "y2":
          y2=int(value[1]);
          break;
        case "f":
          f=float(value[1]);
          break;
        case "s":
          s=boolean(int(value[1]));
          break;
        case "%":
          p=int(value[1]);
          break;
        
      }
    }
  }
  
  void CR(){
    
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
      switch(value[0]){
        case "f":
          f=float(value[1]);
          break;
        case "s":
          s=boolean(int(value[1]));
          break;
        case "%":
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