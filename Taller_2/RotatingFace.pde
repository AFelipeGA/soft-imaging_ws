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
        this.marginY = 75   ;
        this.imageHeight = 398;
        this.imageWidth = 398;
        this.rotationDegrees = PI / 200.0;
        this.rotation = this.rotationDegrees;
        this.container = createGraphics(imageWidth, imageHeight);
    }

    void draw() {
        this.updateMouse();
        this.drawFace();
    }

    void drawFace() {
        this.container.beginDraw();
        this.container.imageMode(CENTER);
        this.container.background(0);
        this.container.translate(this.imageWidth/2, this.imageHeight/2);
        this.container.rotate(this.rotation);
        this.container.image(this.face, 0, 0);
        if (this.imageOver) {
          this.rotation += this.rotationDegrees;
        }
        this.container.endDraw();
        image(this.container, this.marginX, this.marginY);
    }

    void updateMouse() {
        this.imageOver = this.overImage(mouseX, mouseY);
    }

    boolean overImage(int x, int y) {
        return x >= this.marginX && x<= this.marginX + this.imageWidth && y >= this.marginY && y <= this.marginY + this.imageHeight;
    }
}
