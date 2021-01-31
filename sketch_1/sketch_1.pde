import ddf.minim.*;
import ddf.minim.analysis.*;

Minim       minim;
AudioPlayer vox, bass, drums, synths;
FFT         voxFFT, bassFFT, drumsFFT, synthsFFT;

int         myAudioRange     = 256;
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

float       j                = 0;

// ************************************************************************************

color       bgColor          = #333333;

// ************************************************************************************

void setup() {
  size(displayWidth, displayHeight);
  background(bgColor);

  minim   = new Minim(this);
  vox = minim.loadFile("05-1-Groove_Insane_-_Into_The_Groove_Vox.mp3");
  synths = minim.loadFile("04-1-Groove_Insane_-_Into_The_Groove_Synths.mp3");
  bass = minim.loadFile("03-1-Groove_Insane_-_Into_The_Groove_Bass.mp3");
  drums = minim.loadFile("02-1-Groove_Insane_-_Into_The_Groove_Drums.mp3");
  vox.play();
  drums.play();
  bass.play();
  synths.play();

  synthsFFT = new FFT(synths.bufferSize(), synths.sampleRate());
  synthsFFT.linAverages(myAudioRange);
  bassFFT = new FFT(bass.bufferSize(), bass.sampleRate());
  bassFFT.linAverages(myAudioRange);
  voxFFT = new FFT(vox.bufferSize(), vox.sampleRate());
  voxFFT.linAverages(myAudioRange);
  drumsFFT = new FFT(drums.bufferSize(), drums.sampleRate());
  drumsFFT.linAverages(myAudioRange);

  noCursor();
}

void draw() {
  background(bgColor);

  viz(vox, voxFFT, 400, 200, 10);
  viz(drums, drumsFFT, 1000, 200, 10);
  viz(bass, bassFFT, 400, 600, 50);
  viz(synths, synthsFFT, 1000, 600, 10);
  
  
}

void stop() {
  synths.close();
  vox.close();
  bass.close();
  drums.close();
  minim.stop();  
  super.stop();
}


void viz(AudioPlayer ap, FFT ft, int x, int y, float amp){
    
  ft.forward(ap.mix);
  for (int i = 0; i < myAudioRange; ++i) {
    stroke(255);
    strokeWeight(2);
    
    float tempIndexAvg = (ft.getAvg(i) * amp) * myAudioIndexAmp;

    j = map(i, 0, myAudioRange, 0, TWO_PI);

    pushMatrix();
    translate(x, y);
    rotate(j);
    rect( 0, yStart, 0, tempIndexAvg);
    popMatrix();

    myAudioIndexAmp+=myAudioIndexStep;
  }
  myAudioIndexAmp = myAudioIndex;
  
  
  
}