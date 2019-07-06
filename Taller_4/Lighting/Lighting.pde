PShape car;
PShape lamp_1, lamp_2;
PShape street;
PShape trafficLight;

// controls
boolean left_lamp = true;
boolean right_lamp = true;
int traffic_light_color = 1;
boolean specular = true;
boolean front_lights = true;
boolean stop_lights = true;
boolean axis = false;

// scene center
float scene_X = 0; 
float scene_Y = 0; 
float scene_Z = 0; 

// car position
float car_X = scene_X;
float car_Y = scene_Y-10;
float car_Z = scene_Z;

// lamp 1 position
float lamp1_X = scene_X+350;
float lamp1_Y = scene_Y+50;
float lamp1_Z = scene_Z+600;

// lamp 2 position
float lamp2_X = scene_X-350;
float lamp2_Y = scene_Y+50;
float lamp2_Z = scene_Z+600;

// traffic light position
float tlight_X = scene_X-250;
float tlight_Y = scene_Y-350;
float tlight_Z = scene_Z-600;

// camera
float camHeight = -200;    // height above the Scene
float Radius = 1200;  // radius for camera 
float angle = 0;

//mouse
float previous = 0; 

PShader texlightShader;

void setup() {
  size(1080, 720, P3D);  
  car = loadShape("Car/Car.obj");
  lamp_1 = loadShape("Lamp/Lamp.obj");
  lamp_2 = loadShape("Lamp/Lamp.obj");
  trafficLight = loadShape("TrafficLight/TrafficLight.obj");
  street = loadShape("Street/Street.obj");
  texlightShader = loadShader("pixlightxfrag.glsl", "pixlightxvert.glsl");
}

void draw() {    
  colorMode(HSB, 360, 100, 100);
  background(0);
  if(axis) {
    drawAxis();
  }
  CheckCameraMouse ();
  drawScene();
}

void drawScene() {  
  //shader(texlightShader);
  drawLights();

  pushMatrix();
  translate(lamp1_X , lamp1_Y, lamp1_Z);
  shape(lamp_1);
  popMatrix();

  pushMatrix();
  translate(lamp2_X , lamp2_Y, lamp2_Z);
  shape(lamp_2);
  popMatrix();

  pushMatrix();
  translate(tlight_X , tlight_Y, tlight_Z);
  shape(trafficLight);
  popMatrix();

  pushMatrix();  
  translate(scene_X, scene_Y, scene_Z);
  shape(street);  
  popMatrix();

  pushMatrix();  
  shininess(0.2);
  specular(0, 0, 100);
  translate(car_X, car_Y, car_Z);
  shape(car);
  popMatrix();

  //resetShader();
}

void drawLights() {
  ambientLight(0, 0, 10);

  if(specular){
    lightSpecular(0, 0, 40);
  }

  if(right_lamp) {
    pushMatrix();
    translate(lamp1_X , lamp1_Y-350, lamp1_Z);
    stroke(0, 0, 20);
    sphere(10);
    pointLight(31, 33, 50, 0, 0, 0);
    popMatrix();
  }

  /*if(left_lamp) {
    pushMatrix();
    translate(lamp2_X , lamp2_Y-350, lamp2_Z);
    stroke(0, 0, 20);
    sphere(10);
    pointLight(31, 33, 100, 0, 0, 0);
    popMatrix();
  }*/

  if(front_lights) {
    pushMatrix();
    translate(car_X + 90 , car_Y-90, car_Z-365);
    stroke(33, 12, 100);
    sphere(10);
    spotLight(33, 12, 100, 0, 0, 0, 0, 1, -1, PI, 1);
    popMatrix();

    pushMatrix();
    translate(car_X - 90 , car_Y-90, car_Z-365);
    stroke(33, 12, 100);
    sphere(10);
    spotLight(33, 12, 100, 0, 0, 0, 0, 1, -1, PI, 1);
    popMatrix();
  }

  if(specular){
    lightSpecular(0,100,50);
  }

  if(stop_lights) {
    pushMatrix();
    translate(car_X + 85 , car_Y-90, car_Z+370);
    stroke(0, 100, 100);
    sphere(10);
    spotLight(0, 100, 100, 0, 0, 0, 0, 1, 1, PI, 1);
    popMatrix();

    pushMatrix();
    translate(car_X - 85 , car_Y-90, car_Z+370);
    stroke(0, 100, 100);
    sphere(10);
    spotLight(0, 100, 100, 0, 0, 0, 0, 1, 1, PI, 1);
    popMatrix();
  }

  switch (traffic_light_color) {
    case 1: //red
      if(specular){
        lightSpecular(0, 100, 50);
      }
      // TOP
      pushMatrix();
      translate(tlight_X + 220, tlight_Y-100, tlight_Z-25);
      stroke(0, 100, 100);
      sphere(5);
      spotLight(0, 100, 100, 0, 0, 0, 0, 0, 1, PI/4, 0.5);
      popMatrix();
      // SIDE
      pushMatrix();
      translate(tlight_X - 100, tlight_Y+130, tlight_Z+50);
      stroke(0, 100, 100);
      sphere(5);
      spotLight(0, 100, 100, 0, 0, 0, 0, 0, 1, PI/4, 0.5);
      popMatrix();
      break;
    case 2: //yellow
      if(specular){
        lightSpecular(60,100,50);
      }
      // TOP
      pushMatrix();
      translate(tlight_X + 220, tlight_Y-80, tlight_Z-25);
      stroke(60,100,100);
      sphere(5);
      spotLight(60,100,100, 0, 0, 0, 0, 0, 1, PI/4, 0.5);
      popMatrix();
      //SIDE
      pushMatrix();
      translate(tlight_X - 100, tlight_Y+150, tlight_Z+50);
      stroke(60,100,100);
      sphere(5);
      spotLight(60,100,100, 0, 0, 0, 0, 0, 1, PI/4, 0.5);
      popMatrix();
      break;
    case 3: //green
      if(specular){
        lightSpecular(120, 120, 50);
      }
      //TOP
      pushMatrix();
      translate(tlight_X + 220, tlight_Y-60, tlight_Z-25);
      stroke(120, 120, 100);
      sphere(5);
      spotLight(120, 120, 100, 0, 0, 0, 0, 0, 1, PI/4, 0.5);
      popMatrix();
      //SIDE
      pushMatrix();
      translate(tlight_X - 100, tlight_Y+170, tlight_Z+50);
      stroke(120, 120, 100);
      sphere(5);
      spotLight(120, 120, 100, 0, 0, 0, 0, 0, 1, PI/4, 0.5);
      popMatrix();
      break;
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getAmount();
  Radius+=e*20;
  if (Radius < 0) {
    Radius=0;
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP ) {
      camHeight-=50;
    }
    else if (keyCode == DOWN ) {
      camHeight+=50;
    }
    else if (keyCode == LEFT) {
      left_lamp = !left_lamp;
    }
    else if (keyCode == RIGHT) {
      right_lamp = !right_lamp;
    }
  }
  else if(key == 's'){
    specular = !specular;
  }
  else if(key == 't'){
    traffic_light_color = traffic_light_color == 0 ? 1 : 0;
  }
  else if(key == 'f'){
    front_lights = !front_lights;
    println("front_lights: "+front_lights);
  }
  else if(key == 'b'){
    stop_lights = !stop_lights;
  }
  else if(key == ' ') {
    traffic_light_color = traffic_light_color == 3 ? 1 : traffic_light_color + 1;
  }
  else if(key == 'x') {
    axis = !axis;
  }
  
}

void mouseDragged(MouseEvent e) {
  if(e.getX()>previous){
    angle += PI/64;
  }
  else if(e.getX()<previous) {
    angle -= PI/64;
  }
  previous = e.getX();
}

void CheckCameraMouse () {

  PVector camPos = new PVector();
  camPos.x = Radius*sin(angle) + scene_X;
  camPos.y = camHeight;
  camPos.z = Radius*cos(angle) + scene_Z;
  
  camera (
  camPos.x, camPos.y, camPos.z,
  scene_X, scene_Y + camHeight, scene_Z,
  0.0, 1.0, 0.0);
}

void drawAxis() {
  pushStyle();
  stroke(255, 0, 0);
  line(0, 0, 0, 1000, 0, 0);
  stroke(0, 255, 0);
  line(0, 0, 0, 0, 1000, 0);
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, 1000);
  popStyle();
}