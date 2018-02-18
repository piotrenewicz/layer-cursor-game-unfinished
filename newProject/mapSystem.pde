class mapManager{
  String raw[];
  Stage stages[] = new Stage[1];
  int currentStage = 0;
  
  
  void LoadMap(String mapName){
    stages[0] = new Stage();
    raw = loadStrings(mapName+".txt");
    //raw=new String[] {"#1/1$x:1|y:1|x2:35|y2:100|C:0:255:0"};
    
    for(String temp : raw){
      if(temp.charAt(0)=='#'){
        int entry = int(split(split(split(temp, '$')[0], '/')[0], '#')[1]);
        int blockID = int(split(split(temp, '$')[0], '/')[1]);
        String temp2[] = split(split(temp, '$')[1], '|');
        String attribs[][] = new String[temp2.length][];
        for(int i=0; i<temp2.length; i++)attribs[i]=split(temp2[i], ':');
        
        stages[currentStage].addBlock(entry, blockID, attribs);
        
        //now here i would need to pass the data to a layer handling class that doesn't exist yet.
      }else{
        if(temp.charAt(0)=='!'){
          append(stages, new Stage());
          currentStage++;
        }
        if(temp.charAt(0)=='@'){
          stages[currentStage].LC(int(split(temp, '$')[1]));
        }
      }
    }
  }    
  
  void MU(){
    stages[currentStage].MU();
  }
  
  void GU(){
    //println("whole");
    stages[currentStage].GU();
  }
  
  

}


class Stage{
  //ArrayList<Layer> layers = new ArrayList<Layer>();    //doors will lead through stages. Each stage will bundle layers, it will need to help multilayer logic.
  HashMap<Integer,Layer> layers = new HashMap<Integer,Layer>();
  
  int currentLayer = 0;
  
  Stage(){
    layers.put(0, new Layer());
  }
  
  void addLayer(int l){
    print("new layer created");
    layers.put(l, new Layer());                         //i'm moving layers to arraylist
  }
  
  void LC(int l){
    currentLayer=l;
  }
  
  void MU(){
    layers.get(0).MU();
  }
  
  void GU(){
    //println("stage report");
    int LA = layers.size();
    int i=0;
    int j=0;
    while(i<LA){
      if(layers.containsKey(j)){
        layers.get(j).GU();
        j++;
        i++;
      }else{
        j++;
      }
    }
  };
  
  void addBlock(int entry, int blockID, String attribs[][]){
    layers.get(currentLayer).addBlock(entry, blockID, attribs);
  }
  
}

class Layer{
  Body Layer;
  ArrayList<Block> blocks = new ArrayList<Block>();    //layers will need to be smart, they will handle matrix transforms both ways, and contain logic between blocks on many layers.
  
  void addBlock(int entry, int blockID, String attribs[][]){            //blocks switch
    switch(blockID){
      case 1:
        blocks.add(new Plane(attribs));
        break;
      case 2:
        blocks.add(new Door(attribs));
        break;
      case 3:
        blocks.add(new Spawn(attribs));
        break;
      case 4:
        blocks.add(new LayerHolder(attribs));
        break;
      case 5:
        blocks.add(new Slider(attribs));
        break;
      case 6:
        blocks.add(new Rotor(attribs));
        break;
      
      default:
        print("Error:No such Block");
        break;
    }
    
    //append(blocks, new Block(blockID, attribs));  //actually that makes sense/
  }
  
  void CR(){
    BodyDef LayerDef = new BodyDef();
    LayerDef.type = BodyType.DYNAMIC;
    Vec2 spawn = new Vec2(screenX(0,0),screenY(0,0));
    LayerDef.position.set(box2d.coordPixelsToWorld(spawn));
    Layer = box2d.createBody(LayerDef);
    
    for(int i=0; i<blocks.size(); i++){
      pushMatrix();
      translate(
        blocks.get(i).x,
        blocks.get(i).y
      );
      blocks.get(i).CR();
      popMatrix();
      
      switch(blocks.get(i).AU()){
        case 0:
          print("attempted creating NULL block");
          break;
        case 1:
          break;
        case 2:
          /*WeldJointDef  = new WeldJointDef();
    layerWeld.bodyA = Holder;
    layerWeld.bodyB = 
    layerWeld.dampingRatio = 1;
    layerWeld.frequencyHz = 0;
    layerWeld.localAnchorA.set(new Vec2(0,0));
    
    LWeld = (WeldJoint) box2d.world.createJoint(layerWeld);*/
    //weld joint definition here   //problem here, in order to weld layer to funcBlocks we will need accessors to the bodies, and that makes all blocks bodies better. so i guess blocks will weld themselfs at creation.
    // and fixtures will need to happen same way
    
    //the next issue,, welding holders to layer if placed directly and not welding funcBody ends.
          break;
        case 3:
          
          break;
      }
      //ok here so we will need weld joints for funcBody, no box2d components for planes, and just fixtures for blockades (they will get no bodies themselfs).
      // authentication spreaded by int AU(){} 0 - failed, 1 - plane, 2 - funcBody, 3 - blockades,
    }
  }
  
  void DE(){
    
    for(int i=0; i<blocks.size(); i++){
      //here add the code to destroy welds with each block
      blocks.get(i).DE();
    }
    
    box2d.destroyBody(Layer);
    //when layer will get a body this will be the destructor
  }
  
  void MU(){
    for(int i=0; i<blocks.size(); i++){
      pushMatrix();
      //                      translate(layerXPos, layerYPos); <--add this as soon as layer gets a body to read coordinates from.
      //                      rotate(layerAngle);
      translate(
        blocks.get(i).x,
        blocks.get(i).y
      );
      blocks.get(i).MU();
      popMatrix();
    }
    
  }
  
  void GU(){
    //println("layer report");
    //println(blocks.length);
    for(Block current : blocks){
      current.GU();
    }
  }
  
}






/*it's design time:

I will need to design the storage of maps, the way the data will be layed out in a file.

!-will declare a new stage        (stages go from the first in a map to the last.)
@$val -will change the current layer to place blocks on. 
$-will declare attributes


#EntryNumber/blockID$x:val|y:val               //so it goes |x:22|y:56|x2:42|y2:56|     then we parse that into seprate strings and pass it to the block code, that'll process it further.
                                                                                sounds like a plan




#EntryNumber/blockID$x:val|y:val
#EntryNumber/blockID$x:val|y:val
#EntryNumber/blockID$x:val|y:val
@$val
#EntryNumber/blockID$x:val|y:val
#EntryNumber/blockID$x:val|y:val

#EntryNumber/blockID$x:val|y:val
!
text         //and so on
text
@$val
text
!
text
text
@$val
text
!
text
@$val
text 
text
!
text
text 
text

*/