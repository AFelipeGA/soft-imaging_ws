class NeckerCube {
    private boolean squareOver;
    private int sideWidth = 100;
    private float translateX;
    private float translateY;

    NeckerCube() {
        noFill();
        strokeWeight(5);
        strokeCap(ROUND);
        this.translateX = width / 2.0;
        this.translateY = height / 3.0;
        background(0);
        this.squareOver = false;
    }

    void draw() {
        translate(this.translateX, this.translateY);
        this.updateMouse();
        this.drawCube();
    }

    void drawCube() {
        if (squareOver) {
            beginShape(QUADS);
            // -Z "back" face
            this.drawSide(SideType.NEGATIVE_Z, ColorType.BLUE);
            endShape();

            beginShape(LINES);
            // -Y "bottom" face
            this.drawSide(SideType.NEGATIVE_Y, ColorType.BLUE);
            // -Z "back" face
            this.drawSide(SideType.POSITIVE_Y, ColorType.BLUE);
            endShape();

            beginShape(QUADS);
            // +Z "front" face
            this.drawSide(SideType.POSITIVE_Z, ColorType.WHITE);
            endShape();
        } else {
            beginShape(QUADS);
            // +Z "front" face
            this.drawSide(SideType.POSITIVE_Z, ColorType.BLUE);
            // -Z "back" face
            this.drawSide(SideType.NEGATIVE_Z, ColorType.WHITE);
            endShape();

            beginShape(LINES);
            // -Y "bottom" face
            this.drawSide(SideType.NEGATIVE_Y, ColorType.BLUE);
            // +Y "top" face
            this.drawSide(SideType.POSITIVE_Y, ColorType.BLUE);
            endShape();
        }
    }

    void drawSide(int side, color fillColor) {
        stroke(fillColor);
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
        this.squareOver = this.overSquare(mouseX, mouseY);
    }

    boolean overSquare(int x, int y) {
        return x >= this.translateX - 2 * this.sideWidth && x <= this.translateX + this.sideWidth && y >= this.translateY - 2 * this.sideWidth && y <= this.translateY + this.sideWidth;
    }
}
