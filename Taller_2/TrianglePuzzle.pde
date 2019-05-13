class TrianglePuzzle {
    private float rTpositionX, rTpositionY, bSpositionX;
    private float bSpositionY, cSpositionX, cSpositionY;
    private float gTpositionY, gTpositionX;   

    TrianglePuzzle() {
        strokeWeight(1);
        strokeCap(ROUND);

        this.rTpositionX = 500;
        this.bSpositionX = 500;
        this.cSpositionX = 500;
        this.gTpositionX = 500;
        
        this.rTpositionY = 275;
        this.bSpositionY = 275;
        this.cSpositionY = 275;
        this.gTpositionY = 275;
    }

    void updatePositions(){
        if(cSpositionX <= 615){
            cSpositionX += 1;
        }
        if(cSpositionY >= 235){
            cSpositionY -= 1;
        }
        if(gTpositionX <= 800){
            gTpositionX += 2;
        }
        if(gTpositionY >= 155){
            gTpositionY -= 2;
        }
        if(rTpositionX >= 317){
            rTpositionX -= 1;
        }
        if(rTpositionY <= 353){
            rTpositionY += 1;
        }
    }
    void resetPositions(){
        rTpositionX = 500;
        bSpositionX = 500;
        cSpositionX = 500;
        gTpositionX = 500;
        
        rTpositionY = 275;
        bSpositionY = 275;
        cSpositionY = 275;
        gTpositionY = 275;
    }

    void draw() {
        pushMatrix();
            translate(rTpositionX, rTpositionY);
            drawRedTriangle();
        popMatrix();
        pushMatrix();
            translate(bSpositionX, bSpositionY);
            drawBlueShape();
        popMatrix();
        pushMatrix();
            translate(cSpositionX, cSpositionY);
            drawCyanShape();
        popMatrix();
        pushMatrix();
            translate(gTpositionX, gTpositionY);
            drawGreenTriangle();
        popMatrix();
    }

    void drawRedTriangle() {
        pushStyle();
            stroke(255, 0, 0);
            fill(255, 0, 0, 100);
            triangle(0, 0, 300, -120, 300, 0);
        popStyle();
    }
    void drawGreenTriangle() {
        pushStyle();
            stroke(0, 255, 0);
            fill(0, 255, 0, 100);
            triangle(-185, 80, 0, 0, 0, 80);
        popStyle();
    }
    void drawBlueShape() {
        pushStyle();
            stroke(0, 0, 255);
            fill(0, 0, 255, 100);
            beginShape();
                vertex(185, 0);
                vertex(300, 0);
                vertex(300, 80);
                vertex(115, 80);
                vertex(115, 40);
                vertex(185, 40);
            endShape(CLOSE);
        popStyle();
    }
    void drawCyanShape() {
        pushStyle();
            stroke(0, 255, 255);
            fill(0, 255, 255, 100);
            beginShape();
                vertex(0, 0);
                vertex(185, 0);
                vertex(185, 40);
                vertex(70, 40);
                vertex(70, 80);
                vertex(0, 80);
            endShape(CLOSE);
        popStyle();
    }
}
