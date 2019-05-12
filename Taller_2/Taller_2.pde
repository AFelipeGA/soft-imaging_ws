NeckerCube cube;
SphereRotation sphere;

// Class with static variables that emulate an Enum since it is not supported
class SideType {
    static final int POSITIVE_Z = 1;
    static final int NEGATIVE_Z = 2;
    static final int POSITIVE_Y = 3;
    static final int NEGATIVE_Y = 4;
}

// Class with static variables that emulate an Enum since it is not supported
class ColorType {
    static final color WHITE = #FFFFFF;
    static final color BLUE = #106CC9;
    static final color RED = #C12C2C;
}

void setup() {
    size(1000, 500, P3D);
    // cube = new NeckerCube();
    sphere = new SphereRotation();
}

void draw() {
    // cube.draw();
    sphere.draw();
}
