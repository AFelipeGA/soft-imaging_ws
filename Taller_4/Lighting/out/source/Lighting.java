import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import nub.core.*; 
import nub.primitives.*; 
import nub.processing.*; 
import nub.core.constraint.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Lighting extends PApplet {






PGraphics main;

// Nub
Scene scene;
Node car;
Node carLights;
Node headLight1;
Node headLight2;
Node stopLight1;
Node stopLight2;
Node lamp1;
Node lamp1Lights;
Node bulb1;
Node lamp2;
Node lamp2Lights;
Node bulb2;
Node street;
PShape streetShape;
Node trafficLight;
Node trafficLightLights;
Node topRedLight;
Node topYellowLight;
Node topGreenLight;
Node sideRedLight;
Node sideYellowLight;
Node sideGreenLight;

// Constraint
LocalConstraint constraint = new LocalConstraint();

// controls
boolean leftLampControl = true;
boolean rightLampControl = true;
int trafficLightColor = 1;
int headLightsControl = 1; // 0 -> Off ; 1 -> Lows ; 2 -> Highs
boolean stopLightsControl = true;

// scene center
Vector sceneCenter = new Vector(0,0,0);

// car position
Vector carPosition = new Vector(sceneCenter.x(), sceneCenter.y()-10, sceneCenter.z());

// lamp 1 position
Vector lamp1Position = new Vector(sceneCenter.x()+350, sceneCenter.y()+50, sceneCenter.z()+600);

// lamp 2 position
Vector lamp2Position = new Vector(sceneCenter.x()-350, sceneCenter.y()+50, sceneCenter.z()+600);

// traffic light position
Vector trafficLightPosition = new Vector(sceneCenter.x()-250, sceneCenter.y()-350, sceneCenter.z()-600);

// shader
PShader texlightShader, lightingShader;

// variables for shader uniforms
final int MAX_LIGHTS = 10;
int lightCount = 0;
float[] lightPosition = new float[MAX_LIGHTS * 4];
float[] lightNormal = new float[MAX_LIGHTS * 3];
float[] lightAmbient = new float[MAX_LIGHTS * 3];
float[] lightDiffuse = new float[MAX_LIGHTS * 3];
float[] lightSpecular = new float[MAX_LIGHTS * 3];      
float[] lightFalloff = new float[MAX_LIGHTS * 3];
float[] lightSpot = new float[MAX_LIGHTS * 2];

float[] currentLightSpecular = {64, 64, 64};
float[] currentLightFalloff = {3, 0, 0};

public void setup() {
  
  lightingShader = loadShader("lightFrag.glsl", "lightVert.glsl");

  scene = new Scene(this);
  scene.setRadius(800);
  scene.fit();

  constraint.setTranslationConstraint(AxisPlaneConstraint.Type.AXIS, new Vector(0,0,1));

  setupLights();
  setupModels();
}


public void draw() {    
  resetUniforms();
  ambientLight(0, 0, 0);
  addAmbientLight(32, 32, 32);
  shader(lightingShader);
  background(0);
  scene.render();
  addLightsToShader(lightingShader);
}

public void setupModels() {
  car = new Node(scene, loadShape("Car/Car.obj"));
  car.setPosition(carPosition);
  car.setPickingThreshold(0);
  car.setConstraint(constraint);

  lamp1 = new Node(scene, loadShape("Lamp/Lamp.obj"));
  lamp1.setPosition(lamp1Position);
  lamp1.setPickingThreshold(0);
  lamp1.setConstraint(constraint);

  lamp2 = new Node(scene, loadShape("Lamp/Lamp.obj"));
  lamp2.setPosition(lamp2Position);
  lamp2.setPickingThreshold(0);
  lamp2.setConstraint(constraint);

  trafficLight = new Node(scene, loadShape("TrafficLight/TrafficLight.obj"));
  trafficLight.setPosition(trafficLightPosition);
  trafficLight.setPickingThreshold(0);
  trafficLight.setConstraint(constraint);

  street = new Node(scene, loadShape("Street/Street.obj"));
  street.setPosition(sceneCenter);
}

public void setupLights() {
  carLights = new Node(scene);
  carLights.setPosition(carPosition);

  headLight1 = new Node(carLights){
    @Override
    public void graphics(PGraphics pg) {
      setCurrentSpecular(64,64,64);
      switch(headLightsControl){
        case 0:
          // do nothing
          break;
        case 1: // LOWS
          stroke(255, 241, 224);
          sphere(10);
          addSpotLight(255, 241, 224, position().x(), position().y(), position().z(), 0, 1, -1, PI/2, 1);
          break;
        case 2: // HIGHS
          stroke(255, 241, 224);
          sphere(10);
          addSpotLight(255, 241, 224, position().x(), position().y(), position().z(), 0, 0, -1, PI, 1);
          break;
      }
    }
  };
  headLight1.setPosition(Vector.add(carPosition, new Vector(90, -90, -365)));

  headLight2 = new Node(carLights){
    @Override
      public void graphics(PGraphics pg) {
        setCurrentSpecular(64,64,64);
        switch(headLightsControl){
          case 0:
            // do nothing
            break;
          case 1: // LOWS
            stroke(255, 241, 224);
            sphere(10);
            addSpotLight(255, 241, 224, position().x(), position().y(), position().z(), 0, 1, -1, PI/2, 1);
            break;
          case 2: // HIGHS
            stroke(255, 241, 224);
            sphere(10);
            addSpotLight(255, 241, 224, position().x(), position().y(), position().z(), 0, 0, -1, PI, 1);
            break;
        }
      }
  };
  headLight2.setPosition(Vector.add(carPosition, new Vector(-90, -90, -365)));

  stopLight1 = new Node(carLights){
    @Override
    public void graphics(PGraphics pg) {
      setCurrentSpecular(128, 0, 0);
      if(stopLightsControl) {
        stroke(255, 0, 0);
        sphere(10);
        addSpotLight(255, 0, 0, position().x(), position().y(), position().z(), 0, 1, 1, PI/2, 1);
      }
    }
  };
  stopLight1.setPosition(Vector.add(carPosition, new Vector(85, -90, 370)));

  stopLight2 = new Node(carLights){
    @Override
    public void graphics(PGraphics pg) {
      setCurrentSpecular(128, 0, 0);
      if(stopLightsControl) {
        stroke(255, 0, 0);
        sphere(10);
        addSpotLight(255, 0, 0, position().x(), position().y(), position().z(), 0, 1, 1, PI/2, 1);
      }
    }
  };
  stopLight2.setPosition(Vector.add(carPosition, new Vector(-85, -90, 370)));

  lamp1Lights = new Node(scene);
  lamp1Lights.setPosition(lamp1Position);
  
  bulb1 = new Node(lamp1Lights){
    @Override
    public void graphics(PGraphics pg) {
      setCurrentSpecular(128, 107, 85);
      if(rightLampControl) {
        stroke(255, 214, 170);
        sphere(10);
        addPointLight(255, 214, 170, position().x(), position().y(), position().z());
      }
    }
  };
  bulb1.setPosition(Vector.add(lamp1Position, new Vector(0, -350, 0)));
  
  lamp2Lights = new Node(scene);
  lamp2Lights.setPosition(lamp2Position);

  bulb2 = new Node(lamp2Lights){
    @Override
    public void graphics(PGraphics pg) {
      setCurrentSpecular(128, 107, 85);
      if(leftLampControl) {
        stroke(255, 214, 170);
        sphere(10);
        addPointLight(255, 214, 170, position().x(), position().y(), position().z());
      }
    }
  };
  bulb2.setPosition(Vector.add(lamp2Position, new Vector(0, -350, 0)));
  

  trafficLightLights = new Node(scene);
  trafficLightLights.setPosition(trafficLightPosition);

  topRedLight = new Node(trafficLightLights){
    @Override
    public void graphics(PGraphics pg) {
      if(trafficLightColor == 1) {
        setCurrentSpecular(128, 0, 0);
        stroke(255, 0, 0);
        sphere(5);
        addSpotLight(255, 0, 0, position().x(), position().y(), position().z(), 0, 1, 1, PI/2, 0.5f);
      }
    }
  };
  topRedLight.setPosition(Vector.add(trafficLightPosition, new Vector(220, -100, -25)));

  sideRedLight = new Node(trafficLightLights){
    @Override
    public void graphics(PGraphics pg) {
      if(trafficLightColor == 1) {
        setCurrentSpecular(128, 0, 0);
        stroke(255, 0, 0);
        sphere(5);
        addSpotLight(255, 0, 0, position().x(), position().y(), position().z(), 0, 1, 1, PI/2, 0.5f);
      }
    }
  };
  sideRedLight.setPosition(Vector.add(trafficLightPosition, new Vector(-100, +130, +50)));

  topYellowLight = new Node(trafficLightLights){
    @Override
    public void graphics(PGraphics pg) {
      if(trafficLightColor == 2) {
        setCurrentSpecular(128, 128, 0);
        stroke(255, 255, 0);
        sphere(5);
        addSpotLight(255, 255, 0, position().x(), position().y(), position().z(), 0, 1, 1, PI/2, 0.5f);
      }
    }
  };
  topYellowLight.setPosition(Vector.add(trafficLightPosition, new Vector(220, -80, -25)));

  sideYellowLight = new Node(trafficLightLights){
    @Override
    public void graphics(PGraphics pg) {
      if(trafficLightColor == 2) {
        setCurrentSpecular(128, 128, 0);
        stroke(255, 255, 0);
        sphere(5);
        addSpotLight(255, 255, 0, position().x(), position().y(), position().z(), 0, 1, 1, PI/2, 0.5f);
      }
    }
  };
  sideYellowLight.setPosition(Vector.add(trafficLightPosition, new Vector(-100, +150, +50)));

  topGreenLight = new Node(trafficLightLights){
    @Override
    public void graphics(PGraphics pg) {
      if(trafficLightColor == 3) {
        setCurrentSpecular(0, 128, 0);
        stroke(0, 255, 0);
        sphere(5);
        addSpotLight(0, 255, 0, position().x(), position().y(), position().z(), 0, 1, 1, PI/2, 0.5f);
      }
    }
  };
  topGreenLight.setPosition(Vector.add(trafficLightPosition, new Vector(220, -60, -25)));

  sideGreenLight = new Node(trafficLightLights){
    @Override
    public void graphics(PGraphics pg) {
      if(trafficLightColor == 3) {
        setCurrentSpecular(0, 128, 0);
        stroke(0, 255, 0);
        sphere(5);
        addSpotLight(0, 255, 0, position().x(), position().y(), position().z(), 0, 1, 1, PI/2, 0.5f);
      }
    }
  };
  sideGreenLight.setPosition(Vector.add(trafficLightPosition, new Vector(-100, +170, +50)));
}

public void setupShaderUniforms() {

}

public void mouseMoved() {
  scene.cast();
}

public void mouseClicked() {
  if(mouseButton == LEFT && scene.trackedNode() != null){
    if(scene.trackedNode().equals(car)){
      headLightsControl = headLightsControl == 2 ? 0 : headLightsControl + 1;
      if(headLightsControl>0){
        stopLightsControl = true;
      } else {
        stopLightsControl = false;
      }
    }
    else if(scene.trackedNode().equals(lamp1)){
      rightLampControl = !rightLampControl;
    }
    else if(scene.trackedNode().equals(lamp2)){
      leftLampControl = !leftLampControl;
    }
    else if(scene.trackedNode().equals(trafficLight)){
      trafficLightColor = trafficLightColor == 3 ? 0 : trafficLightColor + 1;
    }
  }

  if(mouseButton == RIGHT){}
  else if(mouseButton == LEFT){}
  else if(scene.trackedNode() != null){
    if(scene.trackedNode().equals(car)){
      car.rotate(0,1,0,PI);
      carLights.rotate(0,1,0,PI);
    }
  }
}

public void mouseDragged() {
  if (mouseButton == LEFT && scene.trackedNode() == null){
    scene.spin();
  }
  else if (mouseButton == RIGHT){
    scene.translate();
  }
  else{
    if(scene.trackedNode() == null){
      scene.scale(mouseX - pmouseX);
    }
  }
}

public void mouseWheel(MouseEvent event) {
  scene.moveForward(event.getCount() * 20);
}

public void addAmbientLight(float r, float g, float b){
  lightPosition(lightCount, 0, 0, 0);
  lightNormal(lightCount, 0, 0, 0);
  lightAmbient(lightCount, r, g, b);
  lightDiffuse(lightCount, 0, 0, 0);
  lightSpecular(lightCount, 0, 0, 0);
  noLightSpot(lightCount);
  lightFalloff(lightCount, currentLightFalloff[0], currentLightFalloff[1], currentLightFalloff[2]);
  lightCount ++; 
}

public void addPointLight(float r, float g, float b, float x, float y, float z){
  lightPosition(lightCount, x, y, z);
  lightNormal(lightCount, 0, 0, 0);
  lightAmbient(lightCount, 0, 0, 0);
  lightDiffuse(lightCount, r, g, b);
  lightSpecular(lightCount, currentLightSpecular[0], currentLightSpecular[1], currentLightSpecular[2]);
  noLightSpot(lightCount);
  lightFalloff(lightCount, currentLightFalloff[0], currentLightFalloff[1], currentLightFalloff[2]);
  lightCount++;
}

public void addSpotLight(float r, float g, float b, float x, float y, float z, float dx, float dy, float dz, float angle, float concentration){
  lightPosition(lightCount, x, y, z);
  lightNormal(lightCount, dx, dy, dz);  
  lightAmbient(lightCount, 0, 0, 0);
  lightDiffuse(lightCount, r, g, b);
  lightSpecular(lightCount, currentLightSpecular[0], currentLightSpecular[1], currentLightSpecular[2]);
  lightSpot(lightCount, angle, concentration);
  lightFalloff(lightCount, currentLightFalloff[0], currentLightFalloff[1], currentLightFalloff[2]);
  lightCount++;
}

public void addLightsToShader(PShader sh){
  sh.set("myLightCount", lightCount);
  sh.set("myLightPosition", lightPosition, 4);
  sh.set("myLightNormal", lightNormal, 3);
  sh.set("myLightAmbient", lightAmbient, 3);
  sh.set("myLightDiffuse", lightDiffuse, 3);
  sh.set("myLightSpecular", lightSpecular, 3);
  sh.set("myLightFalloff", lightFalloff, 3);
  sh.set("myLightSpot", lightSpot, 2);
}

public void lightPosition(int num, float x, float y, float z) {
  PGraphicsOpenGL pg = (PGraphicsOpenGL)g;
  lightPosition[4 * num + 0] =
  x*pg.modelview.m00 + y*pg.modelview.m01 + z*pg.modelview.m02 + pg.modelview.m03;
  lightPosition[4 * num + 1] =
  x*pg.modelview.m10 + y*pg.modelview.m11 + z*pg.modelview.m12 + pg.modelview.m13;
  lightPosition[4 * num + 2] =
  x*pg.modelview.m20 + y*pg.modelview.m21 + z*pg.modelview.m22 + pg.modelview.m23;
  lightPosition[4 * num + 3] = 1;
}

public void lightNormal(int num, float dx, float dy, float dz) {
  PGraphicsOpenGL pg = (PGraphicsOpenGL)g;
  float nx =
      dx*pg.modelviewInv.m00 + dy*pg.modelviewInv.m10 + dz*pg.modelviewInv.m20;
    float ny =
      dx*pg.modelviewInv.m01 + dy*pg.modelviewInv.m11 + dz*pg.modelviewInv.m21;
    float nz =
      dx*pg.modelviewInv.m02 + dy*pg.modelviewInv.m12 + dz*pg.modelviewInv.m22;

    float d = PApplet.dist(0, 0, 0, nx, ny, nz);
    if (0 < d) {
      float invn = 1.0f / d;
      lightNormal[3 * num + 0] = invn * nx;
      lightNormal[3 * num + 1] = invn * ny;
      lightNormal[3 * num + 2] = invn * nz;
    } else {
      lightNormal[3 * num + 0] = 0;
      lightNormal[3 * num + 1] = 0;
      lightNormal[3 * num + 2] = 0;
}
}

public void lightAmbient(int num, float r, float g, float b) {
  lightAmbient[3 * num + 0] = normalizeColor(r);
  lightAmbient[3 * num + 1] = normalizeColor(g);
  lightAmbient[3 * num + 2] = normalizeColor(b);
}

public void lightDiffuse(int num, float r, float g, float b) {
  lightDiffuse[3 * num + 0] = normalizeColor(r);
  lightDiffuse[3 * num + 1] = normalizeColor(g);
  lightDiffuse[3 * num + 2] = normalizeColor(b);
}

public void lightSpecular(int num, float r, float g, float b) {
  lightSpecular[3 * num + 0] = normalizeColor(r);
  lightSpecular[3 * num + 1] = normalizeColor(g);
  lightSpecular[3 * num + 2] = normalizeColor(b);
}

public void lightFalloff(int num, float c0, float c1, float c2) {
  lightFalloff[3* num + 0] = c0;
  lightFalloff[3* num + 1] = c1;
  lightFalloff[3* num + 2] = c2;
}

public void lightSpot(int num, float angle, float exponent) {
  lightSpot[2 * num + 0] = Math.max(0, cos(angle));
  lightSpot[2 * num + 1] = exponent;
}

public void noLightSpot(int num) {
  lightSpot[2 * num + 0] = 0;
  lightSpot[2 * num + 1] = 0;
}

public void resetUniforms() {
  lightCount = 0;
  lightPosition = new float[MAX_LIGHTS * 4];
  lightNormal = new float[MAX_LIGHTS * 3];
  lightAmbient = new float[MAX_LIGHTS * 3];
  lightDiffuse = new float[MAX_LIGHTS * 3];
  lightSpecular = new float[MAX_LIGHTS * 3];      
  lightFalloff = new float[MAX_LIGHTS * 3];
  lightSpot = new float[MAX_LIGHTS * 2];
}

public float normalizeColor(float c) {
  return norm(c, 0, 255);
}

public void setCurrentSpecular(float r, float g, float b) {
  currentLightSpecular[0] = r;
  currentLightSpecular[1] = g;
  currentLightSpecular[2] = b;
}

public void setCurrentFalloff(float c0, float c1, float c2) {
  currentLightFalloff[0] = c0;
  currentLightFalloff[1] = c1;
  currentLightFalloff[2] = c2;
}
  public void settings() {  size(1080, 720, OPENGL); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Lighting" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
