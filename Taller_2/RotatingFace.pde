class RotatingFace {
    private boolean imageOver;
    private PImage face;
    private int marginX, marginY;
    private int imageHeight, imageWidth;
    private float rotationDegrees;
    private float rotation;
    private PGraphics container;

    RotatingFace() {
        this.face = loadImage("face.png");
        this.imageOver = false;
        this.marginX = 400;
        this.marginY = 50;
        this.imageHeight = 398;
        this.imageWidth = 398;
        this.rotationDegrees = PI / 100.0;
        this.rotation = this.rotationDegrees;
    }

    void draw() {
        this.updateMouse();
        this.drawFace();
    }

    void drawFace() {
        if (this.imageOver) {
          rotate(this.rotation);
          //translate(this.imageWidth/2, this.imageHeight/2);
        }
        image(this.face, marginX, marginY);
        this.rotation += this.rotationDegrees;
    }

    void updateMouse() {
        this.imageOver = this.overImage(mouseX, mouseY);
    }

    boolean overImage(int x, int y) {
        return x >= this.marginX && x<= this.marginX + this.imageWidth && y >= this.marginY && y <= this.marginY + this.imageHeight;
    }
}
