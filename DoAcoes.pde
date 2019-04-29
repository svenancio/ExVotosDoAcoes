/*
  Ex-Votos Project: (Do)Ação
  by Sergio Venancio
  2019
  
  
  This program was made for (Do)Ação installation, by COM.6. It is a video mapping
  application which uses a series of face images captured previously and projects
  them. By default, six images are loaded per time, they keep changing according to
  random "durations" (see code below)

  Instructions:
  key 'p' - pan mode, click and drag mouse to move the selected image along the screen
  key 'z' - zoom mode, click and drag mouse to zoom in or out the selected image
  keys 1-6 - change the selected image
  spacebar - start or stop recording frames - each frame is put into "video" folder
  
  In order to use this software, place some images inside "faces" folder. This code
  does not handle file format, so make sure you only put images inside this folder 
*/


int numImg = 6;
int currentHead = 0;
int mode = 0; //0-pan, 1-zoom
int initX, initY, initImgX, initImgY, initImgZ;

boolean recording = false;
boolean editing = false;
ArrayList<String> imgPipeline;
int[] durations = new int[numImg];
PImage[] currentImages = new PImage[numImg];
ImgInfo[] currentInfo = new ImgInfo[numImg];

void setup() {
  fullScreen(P3D);
  frameRate(30);
  
  imgPipeline = listFileNames(sketchPath()+"/faces");
  if(imgPipeline == null) exit();
  
  for(int i=0;i<numImg;i++) {
    durations[i] = 1;
    
    //initial distribution of images, these magic numbers can be any value
    currentInfo[i] = new ImgInfo(i*400 - (int)(i/3)*1200,(int)(i/3)*500,0); 
    
    durations[i]--;
    if(durations[i] <= 0) {
      currentImages[i] = loadImage("/faces/"+imgPipeline.get((int)random(imgPipeline.size())));
      durations[i] = (int)random(1,11);
    }
  }
}

void draw() {
  background(0);
  
  if(frameCount % 30 == 0) {
    //change heads
    for(int i=0;i<6;i++) {
      durations[i]--;
      if(durations[i] <= 0) {
        currentImages[i] = loadImage("/faces/"+imgPipeline.get((int)random(imgPipeline.size())));
        durations[i] = (int)random(1,11);
      }
    }
    
    if(recording) saveFrame("video/img_####.jpg");
  }
  
  for(int i=0;i<6;i++) {
    pushMatrix();
    translate(0,0,currentInfo[i].z);
    image(currentImages[i], currentInfo[i].x, currentInfo[i].y);
    popMatrix();
  }
  
  if(editing) {
    if(mode == 0) {
      //pan mode
      currentInfo[currentHead].x = initImgX +(mouseX - initX);
      currentInfo[currentHead].y = initImgY +(mouseY - initY);
    } else if(mode == 1) {
      //zoom mode
      currentInfo[currentHead].z = initImgZ +(mouseX - initX);
    }
  }
}

ArrayList<String> listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    ArrayList<String> resp = new ArrayList<String>();
    
    for(int i=0;i<names.length;i++) {
      resp.add(names[i]);
    }
    
    return resp;
  } else {
    // If it's not a directory
    println("There are no files in this directory");
    return null;
  }
}

void keyPressed() {
  switch(key) {
    case '1':
      currentHead = 0;
      break;
    case '2':
      currentHead = 1;
      break;
    case '3':
      currentHead = 2;
      break;
    case '4':
      currentHead = 3;
      break;
    case '5':
      currentHead = 4;
      break;
    case '6':
      currentHead = 5;
      break;
    case ' ':
      recording = !recording;//start or stop recording frames for video
      break;
    case 'p':
      mode = 0;//mode pan
      break;
    case 'z':
      mode = 1;//mode zoom
      break;
  }
}

void mousePressed() {
  editing = true;
  initX = mouseX;
  initY = mouseY;
  initImgX = currentInfo[currentHead].x;
  initImgY = currentInfo[currentHead].y;
  initImgZ = currentInfo[currentHead].z;
}

void mouseReleased() {
  editing = false;
}

class ImgInfo {
  public int x, y, z;
  
  public ImgInfo(int _x, int _y, int _z) {
    this.x = _x;
    this.y = _y;
    this.z = _z;
  }
}
