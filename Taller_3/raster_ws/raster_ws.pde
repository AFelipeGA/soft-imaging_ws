import nub.timing.*;
import nub.primitives.*;
import nub.core.*;
import nub.processing.*;
import g4p_controls.*;

PGraphics mainWindow;

// View variables
GCheckbox msaaCheckbox, aaCheckbox;

// AntiAliasing selection - 1: AA, 2: MSAA
int antiAliasingSelect = 1;

// 1. Nub objects
Scene scene;
Node node;
Vector v1, v2, v3;
// timing
TimingTask spinningTask;
boolean yDirection;
// scaling is a power of 2
int n = 4;

color c1 = color(255,0,0);
color c2 = color(0,255,0);
color c3 = color(0,0,255); 

int sampling = 1;

// 2. Hints
boolean triangleHint = true;
boolean gridHint = true;
boolean debug = true;
boolean square = false;

// 3. Use FX2D, JAVA2D, P2D or P3D
String renderer = P2D;

// 4. Window dimension
int dim = 9;

//----------------- MSAA sample positions
Vector[] nomsaa = {
  new Vector(0.5, 0.5)
};

Vector[] msaa2x = {
  new Vector(0.75, 0.75),
  new Vector(0.25, 0.25)
};

Vector[] msaa4x = {
  new Vector(0.375, 0.125),
  new Vector(0.875, 0.375),
  new Vector(0.125, 0.625),
  new Vector(0.625, 0.875)
};

Vector[] msaa8x = {
  new Vector(0.5625, 0.3125),
  new Vector(0.4375, 0.6875),
  new Vector(0.8125, 0.5625),
  new Vector(0.3125, 0.1875),
  new Vector(0.1875, 0.8125),
  new Vector(0.0625, 0.4375),
  new Vector(0.6875, 0.9375),
  new Vector(0.9375, 0.0625)
};

Vector[] msaa16x = {
  new Vector(0.5625, 0.5625),
  new Vector(0.4375, 0.3125),
  new Vector(0.3125, 0.625),
  new Vector(0.75, 0.4375),
  new Vector(0.1875, 0.375),
  new Vector(0.625, 0.8125),
  new Vector(0.8125, 0.6875),
  new Vector(0.6875, 0.1875),
  new Vector(0.375, 0.875),
  new Vector(0.5, 0.0625),
  new Vector(0.25,  0.125),
  new Vector(0.125, 0.75),
  new Vector(0, 0.5),
  new Vector(0.9375, 0.25),
  new Vector(0.875, 0.9375),
  new Vector(0.0625, 0)
};

//-------------------- Anti-Aliasing algorithm
Vector[] noaa = {
  new Vector(0.5, 0.5)
};

Vector[] aa2x = {
  new Vector(0.25, 0.5),
  new Vector(0.75, 0.5)
};

Vector[] aa4x = {
  new Vector(0.25, 0.25),
  new Vector(0.75, 0.25),
  new Vector(0.25, 0.75),
  new Vector(0.75, 0.75)
};

Vector[] aa9x = {
  new Vector(0.25, 0.25),
  new Vector(0.50, 0.25),
  new Vector(0.75, 0.25),
  new Vector(0.25, 0.50),
  new Vector(0.50, 0.50),
  new Vector(0.75, 0.50),
  new Vector(0.25, 0.75),
  new Vector(0.50, 0.75),
  new Vector(0.75, 0.75)
};

Vector[] aa16x = {
  new Vector(0.125, 0.125),
  new Vector(0.375, 0.125),
  new Vector(0.625, 0.125),
  new Vector(0.875, 0.125),
  new Vector(0.125, 0.375),
  new Vector(0.375, 0.375),
  new Vector(0.625, 0.375),
  new Vector(0.875, 0.375),
  new Vector(0.125, 0.625),
  new Vector(0.375, 0.625),
  new Vector(0.625, 0.625),
  new Vector(0.875, 0.625),
  new Vector(0.125, 0.875),
  new Vector(0.375, 0.875),
  new Vector(0.625, 0.875),
  new Vector(0.875, 0.875)
};

void settings() {
  size(int(pow(2, dim)), int(pow(2, dim)), renderer);
  noSmooth();
}

void setup() {
  scene = new Scene(this);
  if (scene.is3D())
    scene.setType(Scene.Type.ORTHOGRAPHIC);
  scene.setRadius(width/2);
  scene.fit(1);

  // not really needed here but create a spinning task
  // just to illustrate some nub.timing features. For
  // example, to see how 3D spinning from the horizon
  // (no bias from above nor from below) induces movement
  // on the node instance (the one used to represent
  // onscreen pixels): upwards or backwards (or to the left
  // vs to the right)?
  // Press ' ' to play it
  // Press 'y' to change the spinning axes defined in the
  // world system.
  spinningTask = new TimingTask() {
    @Override
    public void execute() {
      scene.eye().orbit(scene.is2D() ? new Vector(0, 0, 1) :
        yDirection ? new Vector(0, 1, 0) : new Vector(1, 0, 0), PI / 100);
    }
  };
  scene.registerTask(spinningTask);

  node = new Node();
  node.setScaling(width/pow(2, n));

  // init the triangle that's gonna be rasterized
  randomizeTriangle();
  
  //msaaCheckbox = new GCheckbox(this, 0, 0, 500, 25, "Anti-Aliasing Algorithm");
  //aaCheckbox = new GCheckbox(this, 0, 75, 500, 25, "MSAA Algorithm");
}

void draw() {
  background(0);
  stroke(0, 255, 0);
  if (gridHint)
    scene.drawGrid(scene.radius(), (int)pow(2, n));
  if (triangleHint)
    drawTriangleHint();
  pushMatrix();
  pushStyle();
  scene.applyTransformation(node);
  triangleRaster();
  popStyle();
  popMatrix();
  //msaaCheckbox = new GCheckbox(this, 0, 0, 500, 25, "Anti-Aliasing Algorithm");
  //aaCheckbox = new GCheckbox(this, 0, 75, 500, 25, "MSAA Algorithm");
}

// Implement this function to rasterize the triangle.
// Coordinates are given in the node system which has a dimension of 2^n
void triangleRaster() {
  // node.location converts points from world to node
  // here we convert v1 to illustrate the idea
  if (debug) {
    pushStyle();
    int gridSize = (int)pow(2, n);
    Vector p,q,r,aux;
    p = v1;
    q = v2;
    r = v3;
    
    float xMax, yMax, xMin, yMin;
    
    xMax = node.location(p).x();
    yMax = node.location(p).y();
    xMin = xMax;
    yMin = yMax;
    
    if(node.location(q).x() > xMax){
      xMax = node.location(q).x();
    } else if(node.location(q).x() < xMin){
      xMin = node.location(q).x();
    }
    if(node.location(r).x() > xMax){
      xMax = node.location(r).x();
    } else if(node.location(r).x() < xMin){
      xMin = node.location(r).x();
    }
    
    if(node.location(q).y() > yMax){
      yMax = node.location(q).y();
    } else if(node.location(q).y() < yMin){
      yMin = node.location(q).y();
    }
    if(node.location(r).y() > yMax){
      yMax = node.location(r).y();
    } else if(node.location(r).y() < yMin){
      yMin = node.location(r).y();
    }
    
    stroke(255,255,255,1);
    
    // Check for CCW and change vertex order
    if((q.y() - p.y())*(r.x() - q.x())-(q.x()-p.x()) * (r.y()-q.y()) < 0){
      aux = q;
      q = r;
      r = aux;
    }
    
    float area = edgeFunction(p, q, node.location(r).x(), node.location(r).y());
    
    for(int i=floor(xMin); i< ceil(xMax); i++){
      for(int j=floor(yMin); j<ceil(yMax); j++){
        float factor = 0;
        if(antiAliasingSelect == 1)
          factor = aa(sampling, p, q, r, i, j);
        else if(antiAliasingSelect == 2)
          factor = msaa(sampling, p, q, r, i, j);
        
        if (factor > 0) {
            float w0 = edgeFunction(p, q, i+0.5, j+0.5);
            float w1 = edgeFunction(q, r, i+0.5, j+0.5);
            float w2 = edgeFunction(r, p, i+0.5, j+0.5);
            w0 /= area; 
            w1 /= area; 
            w2 /= area; 
            int red = (int)((red(c1) * w0 + red(c2) * w1 + red(c3) * w2));
            int green = (int)((green(c1) * w0 + green(c2) * w1 + green(c3) * w2));
            int blue = (int)((blue(c1) * w0 + blue(c2) * w1 + blue(c3) * w2));
            color c = color(red,green,blue);
            pushStyle();
                colorMode(HSB);
                c = color(hue(c), saturation(c), brightness(c)*factor);
                fill(c);
                square(i, j, 1);
            popStyle();
        } else if(square){
          fill(255);
          square(i, j, 1);
        }
      }
    }
    popStyle();
  }
}

float edgeFunction(Vector a, Vector b, float x, float y) 
{ 
    return (x - node.location(a).x()) * (node.location(b).y() - node.location(a).y()) - (y - node.location(a).y()) * (node.location(b).x() - node.location(a).x()); 
} 

float aa(int samples, Vector a, Vector b, Vector c, float x, float y){
  float cnt = 0;
  Vector[] pattern = {};
  switch(samples){
    case 1:
      pattern = noaa;
      break;
    case 2:
      pattern = aa2x;
      break;
    case 4:
      pattern = aa4x;
      break;
    case 8:
      pattern = aa9x;
      break;
    case 16:
      pattern = aa16x;
      break;
  }
  for(int k=0; k< pattern.length; k++){
    float w0 = edgeFunction(a, b, x + pattern[k].x(), y + pattern[k].y());
    float w1 = edgeFunction(b, c, x+pattern[k].x(), y+pattern[k].y());
    float w2 = edgeFunction(c, a, x+pattern[k].x(), y+pattern[k].y());
    if( w0 >= 0 && w1 >= 0 && w2 >= 0){
       cnt++;
    }
  }
  return cnt/samples;
}
float msaa(int samples, Vector a, Vector b, Vector c, float x, float y){
  float cnt = 0;
  Vector[] pattern = {};
  switch(samples){
    case 1:
      pattern = nomsaa;
      break;
    case 2:
      pattern = msaa2x;
      break;
    case 4:
      pattern = msaa4x;
      break;
    case 8:
      pattern = msaa8x;
      break;
    case 16:
      pattern = msaa16x;
      break;
  }
  for(int k=0; k< pattern.length; k++){
    float w0 = edgeFunction(a, b, x + pattern[k].x(), y + pattern[k].y());
    float w1 = edgeFunction(b, c, x+pattern[k].x(), y+pattern[k].y());
    float w2 = edgeFunction(c, a, x+pattern[k].x(), y+pattern[k].y());
    if( w0 >= 0 && w1 >= 0 && w2 >= 0){
       cnt++;
    }
  }
  return cnt/samples;
}

void randomizeTriangle() {
  int low = -width/2;
  int high = width/2;
  v1 = new Vector(random(low, high), random(low, high));
  v2 = new Vector(random(low, high), random(low, high));
  v3 = new Vector(random(low, high), random(low, high));
  
  // Example of visual bug
  /*v1 = new Vector(177.76111, -163.05533);
  v2 = new Vector(-158.44745, -253.63004);
  v3 = new Vector(-77.3663, 133.94534);*/
}

void randomizeColors(){
  c1 = color(random(255),random(255), random(255));
  c2 = color(random(255),random(255), random(255));
  c3 = color(random(255),random(255), random(255));
}

void drawTriangleHint() {
  pushStyle();
  noFill();
  strokeWeight(2);
  stroke(255, 0, 0);
  triangle(v1.x(), v1.y(), v2.x(), v2.y(), v3.x(), v3.y());
  strokeWeight(5);
  stroke(0, 255, 255);
  point(v1.x(), v1.y());
  point(v2.x(), v2.y());
  point(v3.x(), v3.y());
  popStyle();
}

void keyPressed() {
  if (key == 'g')
    gridHint = !gridHint;
  if (key == 't')
    triangleHint = !triangleHint;
  if (key == 'd')
    debug = !debug;
  if (key == '+') {
    n = n < 7 ? n+1 : 2;
    node.setScaling(width/pow( 2, n));
  }
  if (key == '-') {
    n = n >2 ? n-1 : 7;
    node.setScaling(width/pow( 2, n));
  }
  if (key == 'r')
    randomizeTriangle();
  if (key == 'c'){
    randomizeColors();
  }
  if (key == 's'){
    square = !square;
  }
  if (key == CODED && keyCode == UP){
    sampling = sampling <= 8 ? sampling*2 : 1;
    println(sampling);
  }
  if (key == CODED && keyCode == DOWN){
    sampling = sampling > 1 ? sampling/2 : 16;
    println(sampling);
  }
  if (key == ' ')
    if (spinningTask.isActive())
      spinningTask.stop();
    else
      spinningTask.run(20);
  if (key == 'y')
    yDirection = !yDirection;
}
