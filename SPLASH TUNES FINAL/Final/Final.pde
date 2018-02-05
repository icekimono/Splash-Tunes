import processing.sound.*;
import ddf.minim.*;
import ddf.minim.signals.*; 
import ddf.minim.analysis.*; 
import ddf.minim.effects.*; 

PImage backgroundImage;

Minim minim;
AudioPlayer song;
AudioInput input;
AudioMetaData meta;

SoundFile file;
String[] filenames;

PImage niceImage;
PImage maskedImage;
PGraphics graphicalMask;

int overallMode = 1;

int y = height;
int x = 5;
int yi = 15;
int percentage;
int spacer = 360;

String title;
String album;
String artist;
String genre;
int time;
int minutes;
int seconds;

float volume;

int a = 255;
int b = 0;
int c = 0;
boolean step1 = true; //increase green to max
boolean step2 = false; //decrease red to 0
boolean step3 = false; //increasse blue to max
boolean step4 = false; //decrease green to 0
boolean step5 = false; //increase red to max
boolean step6 = false; //decrease blue to 0

int index = 0;

int waveMultiple = 100;

boolean multiple = false;
boolean colorful = false;
boolean shiftRainbow = false;

boolean makeRed = false;
boolean makeGreen = false;
boolean makeBlue = false;

//1: BW Default
//2: MAGENTA/DARK_PURPLE
//3: PURPLE/DARK_PURPLE
//4: PERI/DARK_PURPLE
//5: DARK_GREEN/DARK_PURPLE
//6: MAGENTA/PURPLE
//7: YELLOW/BLOOD_ORANGE
//8: YELLOW/DARK_GREEN
//9: GREEN/PERI
//10: BABY_PINK/BABY_BLUE
color WHITE = color(255, 255, 255);
color AQUA = color(138, 219, 226);
color MAGENTA = color(231, 97, 108);
color DARK_PURPLE = color(35, 28, 48);
color DARK_GREEN  = color (50, 122, 48);
color PERI = color(75, 103, 196);
color BABY_PINK = color(255, 222, 229);
color BABY_BLUE  = color(103, 194, 232);
color YELLOW  = color(255, 253, 97);
color BLOOD_ORANGE = color(245, 77, 57);
color GREEN = color (151, 244, 146);
color PURPLE = color(183, 88, 166);

boolean isPaused = false;

void settings() {
  size(displayWidth, displayHeight, P3D);
}

void setup() { 
  filenames = listFileNames("C:\\Users\\Kathe\\Documents\\Processing\\MusicToMyEarsVers2\\Songs");
  minim = new Minim(this);
  playSong();
  backgroundChange(1);
}

void draw() {
  image(backgroundImage, 0, 0);
  stroke(255);
  
  volume = song.left.level() * 1000;
  
  if (shiftRainbow) {
    changeUp();
  }
  
  for(int i = 0; i < song.bufferSize() - 1; i++) {
    float x1 = map(i, 0, song.bufferSize(), 0, width );
    float x2 = map(i+1, 0, song.bufferSize(), 0, width);
    
    if (colorful) {
      changeUp();
    }
    else if (!shiftRainbow & !multiple) {
      loudVolume();
    }
    
    if (multiple) {
      for (int j = 0; j < 8; j++) {
        line(x1, song.left.get(i)*waveMultiple + spacer, x2, song.left.get(i+1)*waveMultiple + spacer);
        spacer += height/8;
      }
      spacer = 60;
    }
    else {
      spacer = height/2;
      line(x1, song.left.get(i)*waveMultiple + spacer, x2, song.left.get(i+1)*waveMultiple + spacer);
    }
    
    //FIX
    if((isPaused == false) && (song.isPlaying() == false)) {  //if the song is not playing
      index++;
      if(index == filenames.length){
        index = 0;
        playSong();
      }
      else {
      playSong();    
      }  
    }
    //if(song.position() == song.length()) {
    //  index++;
    //  if(index == filenames.length){
    //    index = 0;
    //    playSong();
    //  }
    //  else {
    //    playSong();    
    //  }
    //}
  }  
   
  noFill();
  stroke(255);
  
  loudVolume();
  
  strokeWeight(4);
  ellipse(width/2, height/2, width/3 + volume, width/3 + volume); 
  strokeWeight(2);
  ellipse(width/2, height/2, width/3 + 20 + volume, width/3 + 20 + volume); 
  
  if (volume > 400) {
    ellipse(width/2, height/2, width/3 + 40 + volume, width/3 + 40 + volume); 
  }
  
  if (volume > 600) {
    ellipse(width/2, height/2, width/3 + 60 + volume, width/3 + 60 + volume); 
  }
  
  stroke(255);
  drawText();
} 

void stop() { 
  song.close(); 
  input.close(); 
  minim.stop(); 

  super.stop();
}

void drawText() {
  //define font size
  int fontSize = 20;
 
  //define base coordinate
  int x_cord = 15;
  int y_cord = height - 120;
  
  //DISPLAY TEXT TO BOTTOM LEFT OF SCREEN
  //title, album, artist, genre, minutes/seconds
  textSize(fontSize);
  
  text("Title: " + title, x_cord, y_cord);
  text("Album: " + album, x_cord, y_cord + 25);
  text("Artist: " + artist, x_cord, y_cord + 50);
  text("Genre: " + genre, x_cord, y_cord + 75);
  timer();
}

String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } 
  else {
    return null;
  }
}


void loudVolume() {
  if (volume > 400) {
    if (makeRed) {
      stroke (255, 0, 0);
    }
    if (makeBlue) {
      stroke (0, 255, 0);
    }
    if (makeGreen) {
      stroke (0, 0, 255);
    }
  }
}

void playSong() {
  song = minim.loadFile("C:\\Users\\Kathe\\Documents\\Processing\\MusicToMyEarsVers2\\Songs\\" + filenames[index]);
  file = new SoundFile(this, "C:\\Users\\Kathe\\Documents\\Processing\\MusicToMyEarsVers2\\Songs\\" + filenames[index]);
  input = minim.getLineIn();
  meta = song.getMetaData();
  
  title = meta.title();
  album = meta.album();
  artist = meta.author();
  genre = meta.genre();
  
  time = meta.length();
  minutes = time/1000/60;
  seconds = time%60;
  
  song.play();
}

void changeUp() {
  stroke (a, b, c);
  if (step1) {
    b = b + 5;
  }
  if (b >= 255) {
    b = 255;
    step1 = false;
    step2 = true;
  } 
  if (step2) {
    a = a - 5;
  }
  if (a <= 0) {
    a = 0;
    step2 = false;
    step3 = true;
  }
  if (step3) {
    c = c + 5;
  }
  if (c >= 255) {
    c = 255;
    step3 = false;
    step4 = true;
  }
  if (step4) {
    b = b - 5;
  }
  if (b <= 0) {
    step4 = false;
    step5 = true;
  }
  if (step5) {
    a = a + 5;
  }
  if (a >= 255) {
    a = 255;
    step5 = false;
    step6 = true;
  }
  if (step6) {
    c = c - 5;
  }
  if (c <= 0) {
    c = 0;
    step6 = false;
    step1 = true;
  } 
}
 
void backgroundChange(int mode) {
  if (mode == 1) {
    overallMode = 1;
    backgroundImage = createImage(width, height, RGB);
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        backgroundImage.pixels[i+j*width] = lerpColor(color(0, 0, 0), color(0, 0, 0), map(j, 0, width, 0, 1));
      }
    }
  }
  else if (mode == 2) {
    overallMode = 2;
    backgroundImage = createImage(width, height, RGB);
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        backgroundImage.pixels[i+j*width] = lerpColor(DARK_PURPLE, MAGENTA, map(j, 0, width, 0, 1));
      }
    }
  }
  else if (mode == 3) {
    overallMode = 3;
    backgroundImage = createImage(width, height, RGB);
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        backgroundImage.pixels[i+j*width] = lerpColor(DARK_PURPLE, PURPLE, map(j, 0, width, 0, 1));
      }
    }
  }
  else if (mode == 4) {
    overallMode = 4;
    backgroundImage = createImage(width, height, RGB);
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        backgroundImage.pixels[i+j*width] = lerpColor(DARK_PURPLE, BABY_BLUE, map(j, 0, width, 0, 1));
      }
    }
  }
  else if (mode == 5) {
    overallMode = 5;
    backgroundImage = createImage(width, height, RGB);
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        backgroundImage.pixels[i+j*width] = lerpColor(DARK_PURPLE, GREEN, map(j, 0, width, 0, 1));
      }
    }
  }
  else if (mode == 6) {
    overallMode = 6;
    backgroundImage = createImage(width, height, RGB);
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        backgroundImage.pixels[i+j*width] = lerpColor(MAGENTA, YELLOW, map(j, 0, width, 0, 1));
      }
    }
  }
  else if (mode == 7) {
    overallMode = 7;
    backgroundImage = createImage(width, height, RGB);
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        backgroundImage.pixels[i+j*width] = lerpColor(YELLOW, BLOOD_ORANGE, map(j, 0, width, 0, 1));
      }
    }
  }
  else if (mode == 8) {
    overallMode = 8;
    backgroundImage = createImage(width, height, RGB);
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        backgroundImage.pixels[i+j*width] = lerpColor(YELLOW, DARK_GREEN, map(j, 0, width, 0, 1));
      }
    }
  }
  else if (mode == 9) {
    overallMode = 9;
    backgroundImage = createImage(width, height, RGB);
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        backgroundImage.pixels[i+j*width] = lerpColor(GREEN, PERI, map(j, 0, width, 0, 1));
      }
    }
  }  
  else {
    overallMode = 0;
    backgroundImage = createImage(width, height, RGB);
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        backgroundImage.pixels[i+j*width] = lerpColor(BABY_PINK, BABY_BLUE, map(j, 0, width, 0, 1));
      }
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    if (song.isPlaying()) {
      isPaused = true;
      song.pause();
    }
    else {
      isPaused = false;
      song.play();
    }
  }
  else if (key == '1') {
    backgroundChange(1);
  }
  else if (key == '2') {
    backgroundChange(2);
  }
  else if (key == '3') {
    backgroundChange(3);
  }
  else if (key == '4') {
    backgroundChange(4);
  }
  else if (key == '5') {
    backgroundChange(5);
  }
  else if (key == '6') {
    backgroundChange(6);
  }
  else if (key == '7') {
    backgroundChange(7);
  }
  else if (key == '8') {
    backgroundChange(8);
  }
  else if (key == '9') {
    backgroundChange(9);
  }
  else if (key == '0') {
    backgroundChange(0);
  }
  else if (key == 'e') {
    multiple = !multiple;  
  }
  else if (key == 'q') {
    waveMultiple -= 25;
    if (waveMultiple < 0) {
      waveMultiple = 0;
    }
  }
  else if (key == 'w') {
    waveMultiple += 25;
  }
  else if (key == 'r') {
    colorful = !colorful; 
    if (shiftRainbow) {
      shiftRainbow = false;
    }
  }
  else if (key == 't') {
    shiftRainbow = !shiftRainbow;
    if (colorful) {
      colorful = false;
    }
  }
  else if (key == 'y') {
    makeRed = !makeRed;
  }
  else if (key == 'u') {
    makeBlue = !makeBlue;
  }
  else if (key == 'i') {
    makeGreen = !makeGreen;
  }  
  else if (keyCode == LEFT) {
      song.pause();
      index--;
      if(index < 0) {
        index = filenames.length - 1;
        playSong();
      }
      else {
        playSong();
      }
    } 
    else if (keyCode == RIGHT) {
      song.pause();
      index++;
      if(index >= filenames.length) {
        index = 0;
        playSong();
      }
     else {
       playSong();
     }
   }
}

void timer() {
  int time = (int) file.duration();
  int minutes = time/60;
  int seconds = time%60;
  int currTime = song.position();
  int currSec = (currTime/1000)%60;
  int currMin = (currTime/1000)/60;
  String currSpace = "";
  String space = "";
  
  int x_cord = 15;
  int y_cord = height - 120;
  
  if (currSec <= 9) {
    currSpace = "0";
  }
  
  if (seconds <= 9) {
    space = "0";
  }
  
  text("Time: " + currMin + ":" + currSpace + currSec + "/" + minutes + ":" + space + seconds, x_cord, y_cord + 100);
}