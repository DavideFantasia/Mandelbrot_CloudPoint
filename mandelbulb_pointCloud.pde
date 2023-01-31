import peasy.*;
int DIM = 64;
PeasyCam cam;
ArrayList<PVector> mandelbulb = new ArrayList<PVector>();

void setup() {
  size(600, 600, P3D);
  windowMove(1200, 100);
  cam = new PeasyCam(this, 500);

  //calcolo dei punti del mandelbulb
  for (int i=0; i<DIM; i++) {
    for (int j=0; j<DIM; j++) {

      boolean edge = false;

      for (int k=0; k<DIM; k++) {
        float x = map(i, 0, DIM, -1, 1);
        float y = map(j, 0, DIM, -1, 1);
        float z = map(k, 0, DIM, -1, 1);

        PVector zeta = new PVector(0, 0, 0);

        int maxIterations = 20;
        int iteration = 0;
        int n = 8;

        while (true) {

          //this is not the C used in the mandelbrot formula
          //this is just the spherical version of zeta
          Spherical c = spherical(zeta.x, zeta.y, zeta.z);

          float newX = pow(c.r, n) * sin(c.theta*n) * cos(c.phi*n);
          float newY = pow(c.r, n) * sin(c.theta*n) * sin(c.phi*n);
          float newZ = pow(c.r, n) * cos(c.theta*n);

          zeta.x = newX + x;//the triplex here (x,y,z) is
          zeta.y = newY + y;//the C seen in the
          zeta.z = newZ + z;//mandelbrot formula

          iteration++;

          if (c.r > 2) {
            if (edge) {
              edge = false;
            }
            break;
          }

          if (iteration>maxIterations) {
            if (!edge) {
              edge = true;
              mandelbulb.add(new PVector(x*100, y*100, z*100));
            }
            break;
          }
        }
      }
    }
  }
}

Spherical spherical(float x, float y, float z) {
  float r = sqrt(x*x + y*y + z*z);
  float theta = atan2( sqrt(x*x + y*y), z);
  float phi = atan2(y, z);

  return new Spherical(r, theta, phi);
}

class Spherical {
  float r, theta, phi;
  Spherical(float r, float theta, float phi) {
    this.r = r;
    this.theta = theta;
    this.phi = phi;
  }
}

void draw() {
  background(0);
  for (PVector v : mandelbulb) {
    stroke(255);
    point(v.x, v.y, v.z);
  }
}
