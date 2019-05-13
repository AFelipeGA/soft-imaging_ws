class DevilsFork {
    private int marginX, marginY;
    private int mouse;
    
    DevilsFork() {
      this.marginX = 500;
      this.marginY = 75;
      this.mouse = 0;
      strokeWeight(4);
    }

    void draw() {
      this.updateMouse();
      this.drawFork();
    }

    void drawFork() {
      noFill();
      stroke(255);
      line(marginX, marginY + 75, marginX, marginY + 300);
      line(marginX + 50, marginY + 75, marginX + 50, marginY + 300);
      line(marginX + 100, marginY + 75, marginX + 100, marginY + 300);
      line(marginX + 150, marginY + 75, marginX + 150, marginY + 300);
      line(marginX + 200, marginY + 75, marginX + 200, marginY + 300);
      line(marginX + 250, marginY + 75, marginX + 250, marginY + 300);
      
      triangle(marginX, marginY + 75, marginX + 50, marginY + 75, marginX + 25, marginY + 25);
      triangle(marginX + 100, marginY + 75, marginX + 150, marginY + 75, marginX + 125, marginY + 25);
      triangle(marginX + 200, marginY + 75, marginX + 250, marginY + 75, marginX + 225, marginY + 25);
      
      arc(marginX + 100, marginY + 300, 200, 200, 0, PI);
      arc(marginX + 100, marginY + 300, 100, 100, 0, PI);
      arc(marginX + 100, marginY + 300, 300, 200, 0, PI/2);
      arc(marginX + 137.5, marginY + 300, 75, 75, PI/2, PI);
      
      fill(255);
      if(this.mouse == 1){
        rect(marginX, marginY, 250, 200);
      }
      else if(this.mouse == 2){
        rect(marginX, marginY+200, 250, 200);
      }
    }
    
    void updateMouse() {
        this.mouse = this.overFigure(mouseX, mouseY);
    }

    int overFigure(int x, int y) {
        if(x >= marginX && x<= marginX + 250 && y >= marginY +75 && y <= marginY + 600){
          if( y<= marginY+200){
            return 1;
          }
          else {
            return 2;
          }
        }
        else{
          return 0;
        }
    }
}
