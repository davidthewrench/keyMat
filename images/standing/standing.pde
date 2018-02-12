import processing.serial.*;

//Setting up String variables to take in Serial data
Serial myPort;

String val = "";

String oldFile;
String newLine;
String[] file;


int temp = 0;

//width of each rectangle
int rectWidth = 50;
int rectHeight = 50;
//setting up variables for data collection
int[] foot = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int[] footLast = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

//graphical coordinates and aesthetic variables
int rectStart[] = {0, 0, 0, 0, 0};
int rectHeightStart[] = {0, 0, 0};

int trans[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

//setting up images for interface
PImage state0; //Hi
PImage state1; //welcome
PImage state2; //lets get started
PImage state3; //loading
PImage state4; //goals background
PImage state5; //calories backgground
PImage state6; //graphs
PImage settingOverlay;
PImage done;
PImage background;


// vaalues for calculating metrics based on data
int state = 0; //change the is to 4 to skip opening animation
int lastState = 0;
int globalTime = 0;
int timeCount = 0;
int time = 0;
float calories = 0;

//values relating to mouse detection
boolean click = false;
int mouse = 0;
int trigger = 0;
int timeTrigger = 0;
float stepRate = 0;
float timeValue = 3600;

//values for Serial connection
int serialFlag = 0;
int serialCount = 0;
int flag = 0;

void setup()
{
  size(480, 560);  
  
  
  rectWidth = width/5 - 4;
  rectHeight = (7*height/9)/3;
  
  
  while(myPort == null && temp < 5)
  {
    findSerial(temp);
    temp++;
    if(myPort == null)
    {
      println("did not find Serial. Checking again");
      temp++;
      delay(1000);
    }
  }
  rectStart[0] = 0;
  rectStart[1] = rectWidth + 5;
  rectStart[2] = 2*rectWidth + 10;
  rectStart[3] = 3*rectWidth + 15;
  rectStart[4] = 4*rectWidth + 20;

  rectHeightStart[0] = height/9+0;
  rectHeightStart[1] = height/9+ rectHeight + 5;
  rectHeightStart[2] = height/9 + 2*rectHeight + 10;;
  

  state0 = loadImage("state0.gif"); //Hi
  state1 = loadImage("state1.gif"); //welcome
  state2 = loadImage("state2.gif"); //lets get started
  state3 = loadImage("state3.gif"); //loading
  state4 = loadImage("state4.png"); //goals background
  state5 = loadImage("state5.png"); //calories backgground
  state6 = loadImage("state6.png"); //graphs
  settingOverlay = loadImage("settings.gif");
  done = loadImage("done.gif");
  background = loadImage("background.png");
  stroke(0xffffffff, 0);

}



void draw()
{
  try {
      if ((myPort.available() > 0))
        serialFlag = 1;
      else
        serialFlag = 0;
    } catch (RuntimeException e) {
          System.out.println("port in use, trying again later...");
          serialFlag = 0;
    }

  //establishing Serial connection and delays one second if it does not find one
  if (serialFlag == 0 && state > 3) 
  {
      findSerial(0);
      delay(100);
  }
  else
  {  // If data is available,
    newLine = myPort.readStringUntil('\n');         // read it and store it in val
    //newLine = "1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1";
    file = split(newLine, ' ');
    println(newLine);
    clear();
    
    footLast[0] = foot[0];
    footLast[1] = foot[1];
    footLast[2] = foot[2];
    footLast[3] = foot[3];
    footLast[4] = foot[4];
    footLast[5] = foot[5];
    footLast[6] = foot[6];
    footLast[7] = foot[7];
    footLast[8] = foot[8];
    footLast[9] = foot[9];
    footLast[10] = foot[10];
    footLast[11] = foot[11];
    footLast[12] = foot[12];
    footLast[13] = foot[13];
    footLast[14] = foot[14];
    
    if(newLine != null)
    {
       try {
         foot[0] = parseInt(file[0]);
      foot[3] = parseInt(file[1]);
      foot[6] = parseInt(file[2]);
      foot[9] = parseInt(file[3]);
      foot[12] = parseInt(file[4]);
      foot[1] = parseInt(file[5]);
      foot[4] = parseInt(file[6]);
      foot[7] = parseInt(file[7]);
      foot[10] = parseInt(file[8]);
      foot[13] = parseInt(file[9]);
      foot[2] = parseInt(file[10]);
      foot[5] = parseInt(file[11]);
      foot[8] = parseInt(file[12]);
      foot[11] = parseInt(file[13]);
      foot[14] = parseInt(file[14]);
       } 
       catch (RuntimeException e) {
          System.out.println("Working on it");
        }
      }


  fill(0xffffff);
  rect(0,0,width, height);

  globalTime++;
  tint(255, 0);
  if(mousePressed == true && mouse == 0)
  { 
  click = true;
  mouse = 1;
  }
  else
    click = false;
  if(!mousePressed)
    mouse = 0;
      
  calorieCount();    
   
    switch(state){
      case 0:
        state0();
        break;
      case 1:
        state1();
        break;
      case 2:
        state2();
        break;
      case 3:
        state3();
        break;
      case 4:
        state4();
        break;
      case 5:
        state5();
        break;
      case 6:
        state6();
        break;
      case 7:
        state7();
        break;
    }
  
  delay(1);
  }
}
void state0()
{
  globalTime+=6;
  tint(255, globalTime);
  image(state0, 0,0,width,height);
  if(globalTime >= 500)
  {
    state = 1;
    globalTime = 0;
    lastState = 0;
  }
}
void state1()
{
  globalTime+=6;
  image(state0, 0,0,width,height);
  tint(255, globalTime);
  image(state1, 0,0,width,height);
  if(globalTime >= 500)
  {
    state = 2;
    globalTime = 0;
    lastState = 1;
  }
}

void state2()
{
  globalTime+=6;
  image(state1, 0,0,width,height);
  tint(255, globalTime);
  image(state2, 0,0,width,height);
  if(globalTime >= 500)
  {
    state = 3;
    globalTime = 0;
    lastState = 2;
  }
}

void state3()
{
  globalTime+=6;
  image(state2, 0,0,width,height);
  tint(255, globalTime);
  image(state3, 0,0,width,height);
  if(globalTime >= 500)
  {
    state = 4;
    globalTime = 0;
    lastState = 3;
  }
}

void state4() //goals page
{
  globalTime+=8;
  
  tint(255, 255);
  image(background, 0, 0, width, height);
  if(lastState == 6)
    image(state6, 0,0,width,height);
  if(lastState == 5)
    image(state5, 0,0,width,height);
    
  tint(255, globalTime);
  image(background, 0, 0, width, height);
  drawFades();
  image(state4, 0,0,width,height);
  tint(255, 255);
  
  
  if(click)
    {
      if(mouseX < 5*width/36 && mouseY < height/9)
      {
         state = 7;
         globalTime = 0;
         lastState = 4;
      }
      if(mouseX < 2*width/3 && mouseX > width/3)
        if(mouseY > 8*height/9 && mouseY < height)
        {
          state = 5;
          globalTime = 0;
         lastState = 4;
        }
      if(mouseX < width && mouseX > 2*width/3)
        if(mouseY > 8*height/9 && mouseY < height)
        {
          state = 6;
          globalTime = 0;
         lastState = 4;
        }
    }
  
}

void state5() //calories
{
  globalTime+=8;
  
    tint(255, 255);
  image(background, 0, 0, width, height);
  if(lastState == 4)
    image(state4, 0,0,width,height);
  if(lastState == 6)
    image(state6, 0,0,width,height);
  
  tint(255, globalTime);
  image(background, 0, 0, width, height);
  drawFades();
  image(state5, 0,0,width,height);
  tint(255, 255);
  
  
  if(click)
  {
    if(mouseX < 5*width/36 && mouseY < height/9)
      {
         state = 7;
         globalTime = 0;
         lastState = 5;
      }
      if(mouseX < 1*width/3 && mouseX > 0)
        if(mouseY > 8*height/9 && mouseY < height)
        {
          state = 4;
          globalTime = 0;
         lastState = 5;
        }
      if(mouseX < width && mouseX > 2*width/3)
        if(mouseY > 8*height/9 && mouseY < height)
        {
          state = 6;
          globalTime = 0;
         lastState = 5;
        }  
  }
  fill(0);
  drawText();
}

void state6() //graphs
{
  globalTime+=8;
  tint(255, 255);
  image(background, 0, 0, width, height);
  if(lastState == 4)
    image(state4, 0,0,width,height);
  if(lastState == 5)
    image(state5, 0,0,width,height);

  tint(255, globalTime);
  image(background, 0, 0, width, height);
  drawFades();
  image(state6, 0,0,width,height);
  tint(255, 255);
  
  if(click)
  {
    if(mouseX < 5*width/36 && mouseY < height/9)
      {
         state = 7;
         globalTime = 0;
         lastState = 6;
      }
    if(mouseX < 1*width/3 && mouseX > 0)
       if(mouseY > 8*height/9 && mouseY < height)
       {
         state = 4;
         globalTime = 0;
         lastState = 6;
       }
     if(mouseX < 2*width/3 && mouseX > width/3)
       if(mouseY > 8*height/9 && mouseY < height)
       {
         state = 5;
         globalTime = 0;
         lastState = 6;
       } 
  }
}
void state7() //settings
{
  globalTime+=6;
  image(state5, 0,0,width,height);
  tint(255, globalTime);
  image(settingOverlay, 0,0,width,height);
  tint(255, 255);
  if(click)
  {
    if(mouseX < 5*width/36 && mouseY < height/9)
      {
         state = lastState;
         globalTime = 0;
         lastState = 7;
      }
    if(mouseX < 1*width/3 && mouseX > 0)
       if(mouseY > 8*height/9 && mouseY < height)
       {
         state = 4;
         globalTime = 0;
         lastState = 7;
       }
     if(mouseX < 2*width/3 && mouseX > width/3)
       if(mouseY > 8*height/9 && mouseY < height)
       {
         state = 5;
         globalTime = 0;
         lastState = 7;
       } 
     if(mouseX > 2*width/3 && mouseX < width)
       if(mouseY > 8*height/9 && mouseY < height)
       {
         state = 6;
         globalTime = 0;
         lastState = 7;
       } 
  }
}
//function to keep track of data. 
//This section can be added to for full data interpretation

void calorieCount()
{
  timeCount++; 
 fill(0, 255); 
 timeValue = 1350;
 stepRate = 0;
 //trigger = 0;
 if(timeCount % 7 == 0)
 {
   for(int i = 0; i<15; i++)
   {
     if(foot[i] > 0)
     {
       //trigger++;
       stepRate++;//just standing adds a little. yes this doesn't account for multiple touches for large feet. bleh
       
     }
     else if(footLast[i] > 0) //they stepped off
     {
         if(footLast[i] < 60) //calling 100 basically the same as standing
         {
           stepRate += 60-footLast[i];
         }
         else
         {
           stepRate += 1;
         }
     }//stepRate while standing can be anywhere between 2 and 100
   }
 }
 if(stepRate > 0)
 {
    if(stepRate >= 0 && stepRate < 4)
      stepRate = 4; //steprate is at least 4 if it is barely being triggered
      
      
    stepRate = stepRate/100 *4.776; //the multiplier to add onto the original formula
    calories = calories + 106.4*stepRate/timeValue;
    println(""+stepRate);
    calories = round( calories * 100.0f ) / 100.0f;
  }
   
 if(calories % 1.8 != 0 && timeTrigger != 1)
 {
   timeTrigger = 1;
 }
 if(timeTrigger == 1 && calories % 1.8 == 0)
 {
   time++;
   timeTrigger = 0;
 }
   
}


//function to draw the dynamic text
void drawText()
{
 
 
  println(""+trigger);
  
  textAlign(CENTER, CENTER);
  textSize(30);
  text(""+calories, width/2, 8*height/16); 
  text("Calories Burned", width/2, 19*height/32); 
  //text(""+time, 23*width/40, 23*height/32); 
  
}


//function for drawing the fading background rectangles
void drawFades()
{

  for(int i = 0; i < 5; i++)
  {
      
    if(foot[0+i*3] > 0)
    {
      if(trans[0+i*3] < 60)
        trans[0+i*3]+=4;
      fill(0xffffffff, trans[0+i*3]);
      rect(rectStart[i], rectHeightStart[0], rectWidth, rectHeight);
    }
    else{
      if(trans[0+i*3] > 0)
        trans[0+i*3] -= 4;
      fill(0xffffffff, trans[0+i*3]);
      rect(rectStart[i], rectHeightStart[0], rectWidth, rectHeight);
    }

    if(foot[1+i*3] > 0)
    {
      if(trans[1+i*3] < 60)
        trans[1+i*3]+=4;
      fill(0xffffffff, trans[1+i*3]);
      rect(rectStart[i], rectHeightStart[1], rectWidth, rectHeight);
    }
    else{
      if(trans[1+i*3] > 0)
        trans[1+i*3] -= 4;
      fill(0xffffffff, trans[1+i*3]);
      rect(rectStart[i], rectHeightStart[1], rectWidth, rectHeight);
    }

    if(foot[2+i*3] > 0)
    {
      if(trans[2+i*3] < 60)
        trans[2+i*3]+=4;
      fill(0xffffffff, trans[2+i*3]);
      rect(rectStart[i], rectHeightStart[2], rectWidth, height);
    }
    else{
      if(trans[2+i*3] > 0)
        trans[2+i*3] -= 4;
      fill(0xffffffff, trans[2+i*3]);
      rect(rectStart[i], rectHeightStart[2], rectWidth, height);
    }
  }
}

//function for establishing a serial connection
void findSerial(int i)
{
    try {
        myPort = new Serial(this, Serial.list()[0], 9600);
        serialFlag = 1;
    } catch (RuntimeException e) {
        if (e.getMessage().contains("<init>")) {
            println("port in use, trying again later...");
            serialFlag = 0;
        }
    }
}