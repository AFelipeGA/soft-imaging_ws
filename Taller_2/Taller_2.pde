import g4p_controls.*;

PGraphics mainWindow;

// View variables
GCheckbox opticalIllusion1, opticalIllusion2, opticalIllusion3;
GCheckbox opticalIllusion4, opticalIllusion5, opticalIllusion6;
boolean isSettedUp1, isSettedUp2, isSettedUp3, isSettedUp4, isSettedUp5, isSettedUp6 = false;

// Illusions
NeckerCube cube;
SphereRotation sphere;

// Class with static variables that emulate an Enum since it is not supported
class SideType {
    static final int POSITIVE_Z = 1;
    static final int NEGATIVE_Z = 2;
    static final int POSITIVE_Y = 3;
    static final int NEGATIVE_Y = 4;
}

// Class with static variables that emulate an Enum since it is not supported
class ColorType {
    static final color WHITE = #FFFFFF;
    static final color BLUE = #106CC9;
    static final color RED = #C12C2C;
}

void setup() {
    size(1000, 550);
    mainWindow = createGraphics(800, 550);
    textSize(25);
    opticalIllusion1 = new GCheckbox(this, 20, 50, 500, 25, "Cubo de Necker");
    opticalIllusion2 = new GCheckbox(this, 20, 75, 500, 25, "Rotación de una esfera");
    opticalIllusion3 = new GCheckbox(this, 20, 100, 500, 25, "Ilusión óptica 3");
    opticalIllusion4 = new GCheckbox(this, 20, 125, 500, 25, "Ilusión óptica 4");
    opticalIllusion5 = new GCheckbox(this, 20, 150, 500, 25, "Ilusión óptica 5");
    opticalIllusion6 = new GCheckbox(this, 20, 175, 500, 25, "Ilusión óptica 6");
}

void draw() {
    mainWindow.beginDraw();

    if (opticalIllusion1.isSelected()) {
        if (!isSettedUp1) {
            cube = new NeckerCube(mainWindow);
            isSettedUp1 = true;
        }
        cube.draw();
    } else {
        isSettedUp1 = false;
    }

    mainWindow.endDraw();
    image(mainWindow, 200, 0);
}
