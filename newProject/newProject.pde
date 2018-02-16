import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import java.util.Map;

Box2DProcessing box2d;

void setup(){
  //size(700, 700);
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0,0);
  
  //fullScreen();
  track.add(new ArrayList<int[]>());  //this is needed for the first cloneSystem run to work.
  mM.LoadMap("map1");
}

mapManager mM = new mapManager();


void draw(){
  box2d.step();
  background(0);
  cloneSystem();
  mM.MU();
  mM.GU();
  
  
}




int switchUtil(String data, String[] cases){
  for(int i=0; i<cases.length; i++){
    if(data.equals(cases[i])){
      return i;
    }
  }
  return -1;
}








int[] temp = new int[2];
IntList counter= new IntList();
ArrayList<ArrayList<int[]>> track = new ArrayList<ArrayList<int[]>>();
int j=0; //where to save the current track;

void cloneSystem(){
  ellipse(mouseX, mouseY, 20, 20);
  int[] temp ={int(mouseX), int(mouseY)};
  track.get(j).add(temp);
  
  for(int i = 0; i<track.size()-1; i++){
    if(counter.get(i)<track.get(i).size()-1){
      counter.set(i, counter.get(i)+1);
      temp = track.get(i).get(counter.get(i));
      ellipse(temp[0], temp[1], 20, 20);
    }
  }
}

void keyPressed(){
  if(key=='s'){
    track.add(new ArrayList<int[]>());
    for(int i =0; i<counter.size(); i++){
      counter.set(i, 0);
    }
    counter.append(0);
    j++;
  }
}