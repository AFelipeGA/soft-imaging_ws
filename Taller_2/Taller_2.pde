/**
 * Rotate Push Pop. 
 * 
 * The push() and pop() functions allow for more control over transformations.
 * The push function saves the current coordinate system to the stack 
 * and pop() restores the prior coordinate system. 
 */
 
float a;                 // Angle of rotation
int num = 1;            // Number of boxes

void setup() { 
  size(640, 360, P3D);
  noStroke();  
} 
 

void draw() {
  
  lights();
  
  background(0, 0, 26);
  translate(width/2, height/2); 
  
  float gray = map(11, 0, num-1, 0, 255);
  pushMatrix();
  fill(gray);
  rotateY(a);
  rotateX(a/2);
  box(200);
  popMatrix();
  
  a += 0.01;    
} 