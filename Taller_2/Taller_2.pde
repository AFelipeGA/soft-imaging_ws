import g4p_controls.*;

PGraphics mainWindow;

// View variables
GCheckbox opticalIllusion1, opticalIllusion2, opticalIllusion3;
GCheckbox opticalIllusion4, opticalIllusion5, opticalIllusion6;
boolean isSettedUp1, isSettedUp2, isSettedUp3, isSettedUp4, isSettedUp5, isSettedUp6 = false;

// Illusions
NeckerCube cube;
SphereRotation sphere;
FigureRotation figureRotation;
TrianglePuzzle puzzle;
RotatingFace face;
DevilsFork fork;

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
    size(1000, 550, P3D);
    mainWindow = createGraphics(800, 550);
    
    textSize(25);
    opticalIllusion1 = new GCheckbox(this, 20, 50, 500, 25, "Cubo de Necker");
    opticalIllusion2 = new GCheckbox(this, 20, 75, 500, 25, "Rotación de una esfera");
    opticalIllusion3 = new GCheckbox(this, 20, 100, 500, 25, "Giración");
    opticalIllusion4 = new GCheckbox(this, 20, 125, 500, 25, "Rompecabezas triangular");
    opticalIllusion5 = new GCheckbox(this, 20, 150, 500, 25, "Cara ambigua");
    opticalIllusion6 = new GCheckbox(this, 20, 175, 500, 25, "Tenedor del diablo");
}

void resetLinesAndFills() {
    noFill();
    noStroke();
}

void resetCheckboxes(int checkbox) {
    switch(checkbox) {
        case 1:
            opticalIllusion2.setSelected(false);
            opticalIllusion3.setSelected(false);
            opticalIllusion4.setSelected(false);
            opticalIllusion5.setSelected(false);
            opticalIllusion6.setSelected(false);
            break;
        case 2:
            opticalIllusion1.setSelected(false);
            opticalIllusion3.setSelected(false);
            opticalIllusion4.setSelected(false);
            opticalIllusion5.setSelected(false);
            opticalIllusion6.setSelected(false);
            break;
        case 3:
            opticalIllusion1.setSelected(false);
            opticalIllusion2.setSelected(false);
            opticalIllusion4.setSelected(false);
            opticalIllusion5.setSelected(false);
            opticalIllusion6.setSelected(false);
            break;
        case 4:
            opticalIllusion1.setSelected(false);
            opticalIllusion2.setSelected(false);
            opticalIllusion3.setSelected(false);
            opticalIllusion5.setSelected(false);
            opticalIllusion6.setSelected(false);
            break;
        case 5:
            opticalIllusion1.setSelected(false);
            opticalIllusion2.setSelected(false);
            opticalIllusion3.setSelected(false);
            opticalIllusion4.setSelected(false);
            opticalIllusion6.setSelected(false);
            break;
        case 6:
            opticalIllusion1.setSelected(false);
            opticalIllusion2.setSelected(false);
            opticalIllusion3.setSelected(false);
            opticalIllusion4.setSelected(false);
            opticalIllusion5.setSelected(false);
            break;
    }
}

void draw() {
    mainWindow.beginDraw();
    mainWindow.background(0);
    mainWindow.endDraw();
    image(mainWindow, 200, 0);

    if (opticalIllusion1.isSelected()) {
        if (!isSettedUp1) {
            resetCheckboxes(1);
            resetLinesAndFills();
            cube = new NeckerCube();
            isSettedUp1 = true;
        }
        cube.draw();
    } else {
        isSettedUp1 = false;
    }

    if (opticalIllusion2.isSelected()) {
        if (!isSettedUp2) {
            resetCheckboxes(2);
            resetLinesAndFills();
            sphere = new SphereRotation();
            isSettedUp2 = true;
        }
        sphere.draw();
    } else {
        isSettedUp2 = false;
    }

    if (opticalIllusion3.isSelected()) {
        if (!isSettedUp3) {
            resetCheckboxes(3);
            figureRotation = new FigureRotation();
            isSettedUp3 = true;
        }
        figureRotation.draw();
    } else {
        isSettedUp3 = false;
    }

    if (opticalIllusion4.isSelected()) {
        if (!isSettedUp4) {
            resetCheckboxes(4);
            puzzle = new TrianglePuzzle();
            isSettedUp4 = true;
        }
        puzzle.draw();
    } else {
        isSettedUp4 = false;
    }
    if (opticalIllusion5.isSelected()) {
        if (!isSettedUp5) {
            resetCheckboxes(5);
            resetLinesAndFills();
            face = new RotatingFace();
            isSettedUp5 = true;
        }
        face.draw();
    } else {
        isSettedUp5 = false;
    }
    if (opticalIllusion6.isSelected()) {
        if (!isSettedUp6) {
            resetCheckboxes(6);
            resetLinesAndFills();
            fork = new DevilsFork();
            isSettedUp6 = true;
        }
        fork.draw();
    } else {
        isSettedUp6 = false;
    }
}

void keyPressed() {
    if (key == CODED) {
        if (keyCode == LEFT && opticalIllusion3.isSelected()) {
            if(figureRotation.currentFigure - 1 < 1){
                figureRotation.changeFigure(3);
            }else{
                figureRotation.changeFigure(figureRotation.currentFigure - 1);
            }
        } else if (keyCode == RIGHT && opticalIllusion3.isSelected()) {
            if(figureRotation.currentFigure + 1 > 3){
                figureRotation.changeFigure(1);
            }else{
                figureRotation.changeFigure(figureRotation.currentFigure + 1);
            }
        } else if (keyCode == UP && opticalIllusion3.isSelected()) {
            if(figureRotation.rotationSpeed + 1 <= 5){
                figureRotation.changeRotationSpeed(figureRotation.rotationSpeed + 1);
            }
        } else if (keyCode == DOWN && opticalIllusion3.isSelected()) {
            if(figureRotation.rotationSpeed - 1 >= 1){
                figureRotation.changeRotationSpeed(figureRotation.rotationSpeed - 1);
            }
        } else if (keyCode == CONTROL && opticalIllusion4.isSelected()){
            puzzle.updatePositions();
        } else if (keyCode == SHIFT && opticalIllusion4.isSelected()){
            puzzle.resetPositions();
        } 
    } 
}
