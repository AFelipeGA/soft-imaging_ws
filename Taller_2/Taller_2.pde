import g4p_controls.*;

PGraphics main;

GCheckbox opticalIllusion1, opticalIllusion2, opticalIllusion3;
GCheckbox opticalIllusion4, opticalIllusion5, opticalIllusion6;

int sideWidth = 100;
boolean squareOver = false;
float translateX;
float translateY;

// Class with static variables that emulate an Enum since it is not supported
class SideType {
    static final int POSITIVE_Z = 1;
    static final int NEGATIVE_Z = 2;
    static final int POSITIVE_Y = 3;
    static final int NEGATIVE_Y = 4;
}

// Class with static variables that emulate an Enum since it is not supported
class ColorType {
    static final int WHITE = 1;
    static final int BLUE = 2;
}

void setup() {
    size(1000, 550);
    main = createGraphics(800, 550);
    textSize(25);
    opticalIllusion1 = new GCheckbox(this, 20, 50, 500, 25, "Cubo de Necker");
    opticalIllusion2 = new GCheckbox(this, 20, 75, 500, 25, "Ilusión óptica 2");
    opticalIllusion3 = new GCheckbox(this, 20, 100, 500, 25, "Ilusión óptica 3");
    opticalIllusion4 = new GCheckbox(this, 20, 125, 500, 25, "Ilusión óptica 4");
    opticalIllusion5 = new GCheckbox(this, 20, 150, 500, 25, "Ilusión óptica 5");
    opticalIllusion6 = new GCheckbox(this, 20, 175, 500, 25, "Ilusión óptica 6");
}

void draw() {
    main.beginDraw();
    main.background(0);
    main.endDraw();
    image(main, 200, 0);
    if(opticalIllusion1.isSelected()){
        setUpNeckerCube();
        drawNeckerCube();
    }
}

/*--------------------- Necket Cube -----------------------*/

void setUpNeckerCube() {
    noFill();
    strokeWeight(5);
    strokeCap(ROUND);
    println("var: "+main.height);
    translateX = 700;
    translateY = 200;
}

void drawNeckerCube() {
    updateMouse();
    drawCube();
}

void drawCube() {
    if (squareOver) {        
        beginShape(QUADS);
        // -Z "back" face
        drawSide(SideType.NEGATIVE_Z, ColorType.BLUE);
        endShape();

        beginShape(LINES);
        // -Y "bottom" face
        drawSide(SideType.NEGATIVE_Y, ColorType.BLUE);
        // -Z "back" face
        drawSide(SideType.POSITIVE_Y, ColorType.BLUE);
        endShape();

        beginShape(QUADS);
        // +Z "front" face
        drawSide(SideType.POSITIVE_Z, ColorType.WHITE);
        endShape();
    } else {
        beginShape(QUADS);
        // +Z "front" face
        drawSide(SideType.POSITIVE_Z, ColorType.BLUE);
        // -Z "back" face
        drawSide(SideType.NEGATIVE_Z, ColorType.WHITE);
        endShape();

        beginShape(LINES);
        // -Y "bottom" face
        drawSide(SideType.NEGATIVE_Y, ColorType.BLUE);
        // +Y "top" face
        drawSide(SideType.POSITIVE_Y, ColorType.BLUE);
        endShape();
    }
}

void drawSide(int side, int colorType) {
    switch (colorType) {
        case ColorType.WHITE:
            stroke(255);
            break;
        case SideType.NEGATIVE_Z:
            stroke(16, 108, 201);          
            break;
    }
    switch (side) {
        case SideType.POSITIVE_Z:
            vertex(translateX, translateY);
            vertex(translateX - 2 * sideWidth, translateY);
            vertex(translateX - 2 * sideWidth, translateY + 2 * sideWidth);
            vertex(translateX, translateY + 2 * sideWidth);
            break;
        case SideType.NEGATIVE_Z:
            vertex(translateX + sideWidth, translateY - 1 * sideWidth);
            vertex(translateX - 1 * sideWidth, translateY - 1 * sideWidth);
            vertex(translateX - 1 * sideWidth, translateY + sideWidth);
            vertex(translateX + sideWidth, translateY + sideWidth);
            break;
        case SideType.NEGATIVE_Y:
            vertex(translateX - 2 * sideWidth, translateY);
            vertex(translateX - 1 * sideWidth, translateY - 1 * sideWidth);
            vertex(translateX - 2 * sideWidth, translateY + 2 * sideWidth);
            vertex(translateX - 1 * sideWidth, translateY + sideWidth);
            break;
        case SideType.POSITIVE_Y:
            vertex(translateX, translateY);
            vertex(translateX + sideWidth, translateY - 1 * sideWidth);
            vertex(translateX, translateY + 2 * sideWidth);
            vertex(translateX + sideWidth, translateY + sideWidth);
            break;
    }
}

void updateMouse() {
    squareOver = overSquare(mouseX, mouseY);
}

boolean overSquare(int x, int y) {
    return x >= translateX - 2 * sideWidth && x <= translateX + sideWidth && y >= translateY - 2 * sideWidth && y <= translateY + sideWidth;
}

/* ------------------------------------------------------------ */