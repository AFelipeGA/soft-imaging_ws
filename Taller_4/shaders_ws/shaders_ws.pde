import g4p_controls.*;
import processing.video.*;

// Class with static variables that emulate an Enum since it is not supported
class ContentType {
  static final int IMAGE = 1;
  static final int VIDEO = 2;
}

PGraphics base, modified; // PGraphics
PImage img, catImg, baboonImg, lenaImg; // Images
Movie video; // Video

PImage label;
PShape can;
PShader eDShader, sharpenShader, bwShader, blurShader, blackWhiteShader;

GButton catButton, baboonButton, lenaButton, videoButton; // Buttons
GCheckbox meanCheck; // Grayscale Buttons
GCheckbox edgeDetectionCheck, sharpenCheck, boxBlurCheck; // Masks Buttons
GCheckbox edgeDetectionSharpenCheck, sharpenShaderCheck, blurShaderCheck, blackWhiteShaderCheck;

int contentType = ContentType.IMAGE;
int modifierType = 1; // 1=GrayScale

boolean isReadyShaderSetup = false;

float[][] sharpenMatrix =  { { 0, -1, 0 } , 
                             { -1, 5, -1 } ,
                             { 0, -1, 0 } } ;

float[][] edgeDetectionMatrix =  { { -1, -1, -1 } , 
                                   { -1, 8, -1 } ,
                                   { -1, -1, -1 } } ;
                                   

float[][] boxBlurMatrix =  { { 1.0/9, 1.0/9, 1.0/9 } , 
                             { 1.0/9, 1.0/9, 1.0/9 } ,
                             { 1.0/9, 1.0/9, 1.0/9 } } ;
                             
void setup() {
  size(1152, 600, P3D);

  eDShader = loadShader("edgeDetectionfrag.glsl");
  sharpenShader = loadShader("sharpenfrag.glsl");
  blurShader = loadShader("blurfrag.glsl");
  blackWhiteShader = loadShader("blackWhitefrag.glsl");

  base = createGraphics(512, 300, P3D);
  modified = createGraphics(512, 300, P3D);
  
  catImg = loadImage("media/cat.jpg");
  baboonImg = loadImage("media/baboon.png");
  lenaImg = loadImage("media/lena.png");
  
  img = catImg;
  video = new Movie(this, "media/cat.mp4");
  video.loop();

  // Content Type Buttons
  catButton = new GButton(this, 25, 400, 100, 30, "Cat");
  catButton.addEventHandler(this, "handleCatButton");
  baboonButton = new GButton(this, 25, 450, 100, 30, "Baboon");
  baboonButton.addEventHandler(this, "handleBaboonButton");
  lenaButton = new GButton(this, 25, 500, 100, 30, "Lena");
  lenaButton.addEventHandler(this, "handleLenaButton");
  videoButton = new GButton(this, 25, 550, 100, 30, "Video");
  videoButton.addEventHandler(this, "handleVideoButton");
  
  // Grayscale Method Buttons
  g4p_controls.G4P.setGlobalColorScheme	(255);
  meanCheck = new GCheckbox(this, 150, 400, 125, 25, "Mean");
  
  // Convolution Buttons
  edgeDetectionCheck = new GCheckbox(this, 275, 400, 125, 25, "Edge Detection");
  sharpenCheck = new GCheckbox(this, 275, 425, 125, 25, "Sharpen");
  boxBlurCheck = new GCheckbox(this, 275, 450, 125, 25, "Box Blur");

  //Checkboxes Shaders
  blackWhiteShaderCheck = new GCheckbox(this, 400, 400, 125, 25, "Black White");
  edgeDetectionSharpenCheck = new GCheckbox(this, 400, 425, 125, 25, "Edge Detection");
  sharpenShaderCheck = new GCheckbox(this, 400, 450, 125, 25, "Sharpen");
  blurShaderCheck = new GCheckbox(this, 400, 475, 125, 25, "Blur");
}

void draw() {
  background(0);

  // Text
  textSize(18);
  fill(255);
  text("Grayscale", 150, 380);
  text("Masks", 275, 380);
  text("Shaders", 400, 380);
  textSize(25);
  text("FPS: " + int(frameRate), 400, 550);

  // Base Canvas
  base.beginDraw();
  base.background(0);
  img.resize(512,300);
  switch(contentType){
    case ContentType.IMAGE:
      base.image(img, 0, 0);
      break;
     case ContentType.VIDEO:
      base.image(video, 0, 0);
      break;
     default:
       break;
  }
  base.endDraw();
  base.loadPixels();
  image(base, 25, 50);
  
  if(blackWhiteShaderCheck.isSelected()){
    blackWhiteShader.set("texture", base);
    filter(blackWhiteShader);
  }
  if(edgeDetectionSharpenCheck.isSelected()){
    eDShader.set("texture", base);
    filter(eDShader);
  }
  if(sharpenShaderCheck.isSelected()){
    sharpenShader.set("texture", base);
    filter(sharpenShader);
  }
  if(blurShaderCheck.isSelected()){
    blurShader.set("texture", base);
    filter(blurShader);
  }

  // Modified Canvas
  modified.beginDraw();
  modified.background(0);
  modified.loadPixels();
  setPixels(base, modified);
  if(meanCheck.isSelected()){
    modified.pixels = blackAndWhite(modified.pixels, 1.0/3, 1.0/3, 1.0/3);
  }
  if(edgeDetectionCheck.isSelected()){
    modified.pixels = applyConvolution(modified.pixels, edgeDetectionMatrix, 3, modified.width);
  }
  if(sharpenCheck.isSelected()){
    modified.pixels = applyConvolution(modified.pixels, sharpenMatrix, 3, modified.width);
  }
  if(boxBlurCheck.isSelected()){
    modified.pixels = applyConvolution(modified.pixels, boxBlurMatrix, 3, modified.width);
  }
  modified.updatePixels();  
  modified.endDraw();

  image(modified, 612, 50);
}

color [] blackAndWhite(color[] pixelArray, float red, float green, float blue) {
  for(int i = 0; i < pixelArray.length; i++){
    float r = red(color(pixelArray[i])) * red;
    float g = green(color(pixelArray[i])) * green;
    float b = blue(color(pixelArray[i])) * blue;
    pixelArray[i] = color(r + g + b);
  }
  return pixelArray;
}

color[] applyConvolution(color[] pixelArray, float[][] matrix, int matrixsize, int imgWidth){
  color [] result = new color[pixelArray.length];
  for(int i=0; i<pixelArray.length; i++){
    result[i] = convolution(i%imgWidth, i/imgWidth, matrix, matrixsize, pixelArray);
  }
  return result;
}

color convolution(int x, int y, float[][] matrix, int matrixsize,  color[] pixelArray) {
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = matrixsize / 2;
  
  for (int i = 0; i < matrixsize; i++ ) {
    for (int j = 0; j < matrixsize; j++ ) {
      
      int xloc = x + i-offset;
      int yloc = y + j-offset;
      int loc = xloc + img.width*yloc;
      
      loc = constrain(loc,0,pixelArray.length-1);
      rtotal += (red(color(pixelArray[loc])) *matrix[i][j] );
      gtotal += (green(color(pixelArray[loc])) * matrix[i][j]);
      btotal += (blue(color(pixelArray[loc])) * matrix[i][j]);
    }
  }
  
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);

  return color(rtotal, gtotal, btotal); 
}

void setPixels(PGraphics in, PGraphics out){
  for(int i=0; i<in.pixels.length; i++){
    out.pixels[i] = in.pixels[i];
  }
}

void movieEvent(Movie m) {
  m.read();
}

public void handleCatButton(GButton button, GEvent event){
  contentType = ContentType.IMAGE;
  img = catImg;
}

public void handleBaboonButton(GButton button, GEvent event){
  contentType = ContentType.IMAGE;
  img = baboonImg;
}

public void handleLenaButton(GButton button, GEvent event){
  contentType = ContentType.IMAGE;
  img = lenaImg;
}

public void handleVideoButton(GButton button, GEvent event){
  contentType = ContentType.VIDEO;
}