#include <Adafruit_NeoPixel.h>
#include <avr/power.h> // Comment out this line for non-AVR boards (Arduino Due, etc.)

#define PIN 13

int col1[] = {2, 3, 4};
int col2[] = {5, 6, 7};
int col3[] = {8, 9, 10};
int col4[] = {11, 12, A0};
int col5[] = {A1, A2, A3};

int col1Color = 0;
int col2Color = 0;
int col3Color = 0;
int col4Color = 0;
int col5Color = 0;

//fade speed
int fade = 5;

//which LED in the strip is starting
int start = 13;
//how many LEDs are in each column
int piece = (60-15)/5;
//max intensity of color
int colorMax = 100;

String sent = "";

Adafruit_NeoPixel strip = Adafruit_NeoPixel(60, PIN, NEO_GRB + NEO_KHZ800);

//array of values to end up through Serial for metric gathering
int count[] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

void setup() {

Serial.begin(9600);

for(int i = 0; i < 3; i++)
{
  pinMode(col1[i], INPUT);
  pinMode(col2[i], INPUT);
  pinMode(col3[i], INPUT);
  pinMode(col4[i], INPUT);
  pinMode(col5[i], INPUT);
}


strip.begin();
strip.show();

}

void loop() {
  //conditionals to determine inputs and color responses per columns
  for(int i = 0; i < 3; i++)
  {
      if(digitalRead(col1[i]))
      {
        count[i*5+0]++;
        col1Color+=fade;
      }
      else
      {
        count[i*5+0] = 0;
        if(count[0] == 0 && count[5] == 0 && count[10] == 0)
          if(col1Color > 0)
            col1Color-=fade;
      }

      if(digitalRead(col2[i]))
      {
        count[i*5+1]++;
        col2Color+=fade;
      }
      else
      {
        count[i*5+1] = 0;
        if(count[1] == 0 && count[6] == 0 && count[11] == 0)
          if(col2Color > 0)
            col2Color-=fade;
      }
     
      if(digitalRead(col3[i]))
      {
        count[i*5+2]++;
        col3Color+= fade;
      }
      else
      {
        count[i*5+2] = 0;
        if(count[2] == 0 && count[7] == 0 && count[12] == 0)
          if(col3Color > 0)
            col3Color-=fade;
      }
        
      if(digitalRead(col4[i]))
      {
        count[i*5+3]++;
        col4Color+=fade;
      }
      else
      {
        count[i*5+3] = 0;
        if(count[3] == 0 && count[8] == 0 && count[13] == 0)
          if(col4Color > 0)
            col4Color-=fade;
      }
        
      if(digitalRead(col5[i]))
      {
        count[i*5+4]++;
        col5Color+=fade;
      }
      else
      {
        count[i*5+4] = 0;
        if(count[4] == 0 && count[9] == 0 && count[14] == 0)
          if(col5Color > 0)
            col5Color-=fade;
      }
  }
  //edge checking
  if(col1Color>colorMax*2)
    col1Color = colorMax*2;
  if(col2Color>colorMax*2)
    col2Color = colorMax*2;
  if(col3Color>colorMax*2)
    col3Color = colorMax*2;
  if(col4Color>colorMax*2)
    col4Color = colorMax*2;
  if(col5Color>colorMax*2)
    col5Color = colorMax*2;

   //changing the colors based on how long the colors have beeen on
   for(int j = 0; j < piece; j++)
   {
    if(col1Color < colorMax)
     strip.setPixelColor(0*piece+j+start, strip.Color(col1Color, colorMax, 0));
    else
     strip.setPixelColor(0*piece+j+start, strip.Color(colorMax, colorMax, col1Color-colorMax));
    if(col2Color < colorMax)
     strip.setPixelColor(1*piece+j+start, strip.Color(col2Color, colorMax,0));
    else
     strip.setPixelColor(1*piece+j+start, strip.Color(colorMax, colorMax, col2Color-colorMax));
    if(col3Color < colorMax)
     strip.setPixelColor(2*piece+j+start, strip.Color(col3Color, colorMax,0));
    else
     strip.setPixelColor(2*piece+j+start, strip.Color(colorMax, colorMax, col3Color-colorMax));
    if(col4Color < colorMax)
     strip.setPixelColor(3*piece+j+start, strip.Color(col4Color, colorMax,0));
    else
     strip.setPixelColor(3*piece+j+start, strip.Color(colorMax, colorMax, col4Color-colorMax));
    if(col5Color < colorMax)
     strip.setPixelColor(4*piece+j+start, strip.Color(col5Color, colorMax,0));
    else
     strip.setPixelColor(4*piece+j+start, strip.Color(colorMax, colorMax, col5Color-colorMax));
    
    strip.show();

   }
   if(col5Color < colorMax)
     strip.setPixelColor(58, strip.Color(col5Color, colorMax,0));
   else
     strip.setPixelColor(58, strip.Color(colorMax, colorMax, col5Color-colorMax));
    
   strip.show();

  sent = "";
  for(int i = 0; i < 3; i++)
  {
    
    sent += count[i*5+0];
    sent += " ";
    sent += count[i*5+1];
    sent += " ";
    sent += count[i*5+2];
    sent += " ";
    sent += count[i*5+3];
    sent += " ";
    sent += count[i*5+4];
    sent += " ";

  }

  Serial.println(sent);
  delay(100);
  

}
