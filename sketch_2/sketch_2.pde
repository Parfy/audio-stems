import ddf.minim.*;
import ddf.minim.analysis.*;

Minim       minim;
AudioPlayer vox, bass, drums, synths;
FFT         voxFFT, bassFFT, drumsFFT, synthsFFT;

int         myAudioRange     = 16;
int         myAudioMax       = 100;

float       myAudioAmp       = 10.0;
float       myAudioIndex     = 0.05;
float       myAudioIndexAmp  = myAudioIndex;
float       myAudioIndexStep = 0.025;

// ************************************************************************************

int         rectSize         = 2;

int         stageMargin      = 100;
int         stageWidth       = (myAudioRange * rectSize) + (stageMargin * 2);
int         stageHeight      = 700;

float       xStart           = stageMargin;
float       yStart           = stageMargin;
int         xSpacing         = rectSize;

float       j,k                = 0;

// ************************************************************************************

color       bgColor          = #333333;

// ************************************************************************************

void setup() {
  //size(displayWidth, displayHeight, P3D);
  fullScreen(P3D);
  background(bgColor);

  minim   = new Minim(this);
  vox = minim.loadFile("05-1-Groove_Insane_-_Into_The_Groove_Vox.mp3");
  synths = minim.loadFile("04-1-Groove_Insane_-_Into_The_Groove_Synths.mp3");
  bass = minim.loadFile("03-1-Groove_Insane_-_Into_The_Groove_Bass.mp3");
  drums = minim.loadFile("02-1-Groove_Insane_-_Into_The_Groove_Drums.mp3");
  vox.play();
  drums.play();
  bass.play();
 // synths.play();

  synthsFFT = new FFT(synths.bufferSize(), synths.sampleRate());
  synthsFFT.linAverages(myAudioRange);
  bassFFT = new FFT(bass.bufferSize(), bass.sampleRate());
  bassFFT.linAverages(myAudioRange);
  voxFFT = new FFT(vox.bufferSize(), vox.sampleRate());
  voxFFT.linAverages(myAudioRange);
  drumsFFT = new FFT(drums.bufferSize(), drums.sampleRate());
  drumsFFT.linAverages(myAudioRange);

  noCursor();
  noFill();
  strokeWeight(3);
  colorMode(HSB);
}

void draw() {
//  background(bgColor);

//  viz(vox, voxFFT, 400, 200, 10);
//  viz(drums, drumsFFT, 1000, 200, 10);
//  viz(bass, bassFFT, 400, 600, 50);
//  viz(synths, synthsFFT, 1000, 600, 10);
  
  background(0); //black
  translate(width/2+400, height/2+200, 300);
  rotateX(radians(60));
  for (int i = 0; i < 12; i++){
    float theta = -PI/6 * i;
    float x = 200 * sin(theta);
    float y = 200 * cos(theta);
    translate(x,-y,0);
    viz(drums, drumsFFT, 10);
    viz(vox, voxFFT, 10);

  }
  j += 0.01;
  k = 50*(1+sin(j));
}

void stop() {
  synths.close();
  vox.close();
  bass.close();
  drums.close();
  minim.stop();  
  super.stop();
}


void viz(AudioPlayer ap, FFT ft, float amp){
    
  ft.forward(ap.mix);
  blendMode(ADD);
  for (int i = 0; i < myAudioRange; ++i) { 
    float tempIndexAvg = (ft.getAvg(i) * amp) * myAudioIndexAmp;
    pushMatrix();
    float diam = 120 + tempIndexAvg*10;
    int y = i*20;
    stroke(i*10+k, 200, 250); //rainbow colors
    strokeWeight(2);
    translate(0, 0, y);
    ellipse(0, 0, diam, diam);
    strokeWeight(5);
    stroke(i*10+k, 200, 150); //rainbow colors
    ellipse(0, 0, diam, diam);
    popMatrix();
    myAudioIndexAmp+=myAudioIndexStep;
  }
    myAudioIndexAmp = myAudioIndex;
  
  
}