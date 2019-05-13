class FigureRotation {
    private float positionX;
    private float positionY;
    private int rotation;
    public int currentFigure;
    public int rotationSpeed;
    
    FigureRotation() {
        stroke(0, 0, 255);
        strokeWeight(1);
        strokeCap(ROUND);
        textSize(10);
        
        this.positionX = 600;
        this.positionY = 275;
        this.rotation = 0;
        this.currentFigure = 1; // 1: rect, 2: triangle, 3: polygon
        this.rotationSpeed = 2;
    }

    void draw() {
      if(rotation > 360){
        rotation = 0;
      }
      pushMatrix();
        translate(positionX, positionY);
        rotate(radians(rotation));
        drawFigure();
      popMatrix();
      rotation += rotationSpeed;
      pushStyle();
        fill(0);
        text("x", positionX, positionY);
      popStyle();      
    }

    void drawFigure() {
        if(currentFigure == 1){
          fill(0, 0, 255);
          rect(-100, -100, 200, 200);
          fill(255, 255, 255);
          rect(-85, -85, 170, 170);
        } else if(currentFigure == 2){
          fill(0, 0, 255);
          triangle(0, -115, 100, 80, -100, 80);
          fill(255, 255, 255);
          triangle(0, -85, 80, 65, -80, 65);
        } else if(currentFigure == 3){
          fill(0, 0, 255);
          float angle = TWO_PI / 6;
          beginShape();
            for (float a = 0; a < TWO_PI; a += angle) {
              float sx = cos(a) * 110;
              float sy = sin(a) * 110;
              vertex(sx, sy);
            }
          endShape(CLOSE);
          fill(255, 255, 255);
          beginShape();
            for (float a = 0; a < TWO_PI; a += angle) {
              float sx = cos(a) * 90;
              float sy = sin(a) * 90;
              vertex(sx, sy);
            }
          endShape(CLOSE);
        }
    }
    
    void changeFigure(int option){
      this.currentFigure = option;
    }
    void changeRotationSpeed(int speed){
      this.rotationSpeed = speed;
    }
}
