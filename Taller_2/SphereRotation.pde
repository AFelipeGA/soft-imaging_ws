class SphereRotation {
    private float radio;
    private int points;
    private float rotationDegrees;
    private float rotateY;
    Ellipse[] ellipses;

    SphereRotation() {
        this.radio = height / 3.0;
        this.points = 5000;
        this.rotationDegrees = PI / 50.0;
        this.rotateY = this.rotationDegrees;
        this.ellipses = new Ellipse[points];
        for (int i = 0; i < points; i++) {
            this.ellipses[i] = new Ellipse(this.radio);
        }
    }

    void draw() {
        background(215);
        translate(width / 2.0, height / 2.0);
        rotateY(rotateY);

        for (int i = 0; i < this.points; i++) {
            pushMatrix();
            translate(this.ellipses[i].x, this.ellipses[i].y, this.ellipses[i].z);
            fill(ColorType.RED);
            ellipse(0, 0, 5, 5);
            popMatrix();
        }

        this.rotateY += rotationDegrees;
    }
}

class Ellipse {
    int x, y, z;

    Ellipse(float radio) {
        float angleA = random(0, TWO_PI);
        float angleB = random(0, TWO_PI);

        this.x = int(radio * sin(angleA) * cos(angleB));
        this.y = int(radio * sin(angleA) * sin(angleB));
        this.z = int(radio * cos(angleA));
    }
}
