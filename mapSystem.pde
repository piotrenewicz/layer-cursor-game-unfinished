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
  
  void MU(){
    for(int i=0; i<blocks.size(); i++){
      pushMatrix();
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
  void GU(){
    //println("the real problem lies here");
  };                     //this stuff will act as accessors to our childs.
  
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
  
  void MU(){
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