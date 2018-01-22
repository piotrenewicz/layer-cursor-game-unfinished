import java.util.Map;

void setup(){
  size(700, 700);
  //fullScreen();
  track.add(new ArrayList<int[]>());  //this is needed for the first cloneSystem run to work.
  mM.LoadMap("map1");
}

mapManager mM = new mapManager();


void draw(){
  background(0);
  cloneSystem();
  mM.MU();
  mM.GU();
  
  
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