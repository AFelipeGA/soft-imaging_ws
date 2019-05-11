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
    size(1000, 500);
    setUpNeckerCube();
}

void draw() {
    drawNeckerCube();
}

void setUpNeckerCube() {
    noFill();
    strokeWeight(5);
    strokeCap(ROUND);
    translateX = width / 2.0;
    translateY = height / 3.0;
}

void drawNeckerCube() {
    background(0);
    translate(translateX, translateY);
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
            vertex(0, 0);
            vertex(-2 * sideWidth, 0);
            vertex(-2 * sideWidth, 2 * sideWidth);
            vertex(0, 2 * sideWidth);
            break;
        case SideType.NEGATIVE_Z:
            vertex(sideWidth, -1 * sideWidth);
            vertex(-1 * sideWidth, -1 * sideWidth);
            vertex(-1 * sideWidth, sideWidth);
            vertex(sideWidth, sideWidth);
            break;
        case SideType.NEGATIVE_Y:
            vertex(-2 * sideWidth, 0);
            vertex(-1 * sideWidth, -1 * sideWidth);
            vertex(-2 * sideWidth, 2 * sideWidth);
            vertex(-1 * sideWidth, sideWidth);
            break;
        case SideType.POSITIVE_Y:
            vertex(0, 0);
            vertex(sideWidth, -1 * sideWidth);
            vertex(0, 2 * sideWidth);
            vertex(sideWidth, sideWidth);
            break;
    }
}

void updateMouse() {
    squareOver = overSquare(mouseX, mouseY);
}

boolean overSquare(int x, int y) {
    return x >= translateX - 2 * sideWidth && x <= translateX + sideWidth && y >= translateY - 2 * sideWidth && y <= translateY + sideWidth;
}
