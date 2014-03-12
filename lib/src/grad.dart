part of noise;

class Grad {
  double x, y, z;
  Grad(this.x, this.y, this.z);

  double dot2(double x, double y) {
      return this.x*x + this.y*y;
  }

  double dot3(double x, double y, double z) {
      return this.x*x + this.y*y + this.z*z;
  }
}