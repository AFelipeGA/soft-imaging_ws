class NeckerCube {
    private boolean squareOver;
    private int sideWidth = 100;
    private float translateX;
    private float translateY;

    NeckerCube() {
        noFill();
        strokeWeight(5);
        strokeCap(ROUND);
        this.translateX = width / 2.0 + 200;
        this.translateY = height / 3.0;
        this.squareOver = false;
    }

    void draw() {
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
                vertex(this.translateX, this.translateY);
                vertex(this.translateX - 2 * sideWidth, this.translateY);
                vertex(this.translateX - 2 * sideWidth, this.translateY + 2 * sideWidth);
                vertex(this.translateX, this.translateY + 2 * sideWidth);
                break;
            case SideType.NEGATIVE_Z:
                vertex(this.translateX + sideWidth, this.translateY - sideWidth);
                vertex(this.translateX - sideWidth, this.translateY - sideWidth);
                vertex(this.translateX - sideWidth, this.translateY + sideWidth);
                vertex(this.translateX + sideWidth, this.translateY + sideWidth);
                break;
            case SideType.NEGATIVE_Y:
                vertex(this.translateX - 2 * sideWidth, this.translateY);
                vertex(this.translateX - sideWidth, this.translateY - sideWidth);
                vertex(this.translateX - 2 * sideWidth, this.translateY + 2 * sideWidth);
                vertex(this.translateX - sideWidth, this.translateY + sideWidth);
                break;
            case SideType.POSITIVE_Y:
                vertex(this.translateX, this.translateY);
                vertex(this.translateX + sideWidth, this.translateY - sideWidth);
                vertex(this.translateX, this.translateY + 2 * sideWidth);
                vertex(this.translateX + sideWidth, this.translateY + sideWidth);
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
