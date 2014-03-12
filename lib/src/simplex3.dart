part of noise;

class Simplex3 extends ANoise {

  Simplex3([int seed = 0]){
    _seed(seed);
  }

  double noise(double x, double y, double z){
    double n0, n1, n2, n3; // Noise contributions from the three corners

    // Skew the input space to determine which simplex cell we're in
    double s = (x + y + z) * _F3; // Hairy factor for 2D
    int i = (x + s).floor();
    int j = (y + s).floor();
    int k = (z + s).floor();

    double t = (i + j + k) * _G3;
    double x0 = x - i + t; // The x,y,z distances from the cell origin, unskewed.
    double y0 = y - j + t;
    double z0 = z - k + t;

    // For the 3D case, the simplex shape is a slightly irregular tetrahedron.
    // Determine which simplex we are in.
    int i1, j1, k1; // Offsets for second corner of simplex in (i,j,k) coords
    int i2, j2, k2; // Offsets for third corner of simplex in (i,j,k) coords
    if(x0 >= y0) {
      if(y0 >= z0){
        i1=1; j1=0; k1=0; i2=1; j2=1; k2=0;
      } else if(x0 >= z0) {
        i1=1; j1=0; k1=0; i2=1; j2=0; k2=1;
      } else {
        i1=0; j1=0; k1=1; i2=1; j2=0; k2=1;
      }
    } else {
      if(y0 < z0) {
        i1=0; j1=0; k1=1; i2=0; j2=1; k2=1;
      } else if(x0 < z0) {
        i1=0; j1=1; k1=0; i2=0; j2=1; k2=1;
      } else {
        i1=0; j1=1; k1=0; i2=1; j2=1; k2=0;
      }
    }

    // A step of (1,0,0) in (i,j,k) means a step of (1-c,-c,-c) in (x,y,z),
    // a step of (0,1,0) in (i,j,k) means a step of (-c,1-c,-c) in (x,y,z), and
    // a step of (0,0,1) in (i,j,k) means a step of (-c,-c,1-c) in (x,y,z), where
    // c = 1/6.
    double x1 = x0 - i1 + _G3; // Offsets for second corner
    double y1 = y0 - j1 + _G3;
    double z1 = z0 - k1 + _G3;

    double x2 = x0 - i2 + 2 * _G3; // Offsets for third corner
    double y2 = y0 - j2 + 2 * _G3;
    double z2 = z0 - k2 + 2 * _G3;

    double x3 = x0 - 1 + 3 * _G3; // Offsets for fourth corner
    double y3 = y0 - 1 + 3 * _G3;
    double z3 = z0 - 1 + 3 * _G3;

    // Work out the hashed gradient indices of the four simplex corners
    i &= 255;
    j &= 255;
    k &= 255;

    Grad gi0 = _gradP[i + _perm[j + _perm[k]]];
    Grad gi1 = _gradP[i + i1 + _perm[j + j1 + _perm[k + k1]]];
    Grad gi2 = _gradP[i + i2 + _perm[j + j2 + _perm[k + k2]]];
    Grad gi3 = _gradP[i + 1 + _perm[j + 1+_perm[k + 1]]];

    // Calculate the contribution from the four corners
    double t0 = 0.5 - x0 * x0 - y0 * y0 - z0 * z0;
    if(t0 < 0) {
      n0 = 0.0;
    } else {
      t0 *= t0;
      n0 = t0 * t0 * gi0.dot3(x0, y0, z0);  // (x,y) of grad3 used for 2D gradient
    }
    double t1 = 0.5 - x1 * x1 - y1 * y1 - z1 * z1;
    if(t1 < 0) {
      n1 = 0.0;
    } else {
      t1 *= t1;
      n1 = t1 * t1 * gi1.dot3(x1, y1, z1);
    }
    double t2 = 0.5 - x2 * x2 - y2 * y2 - z2 * z2;
    if(t2 < 0) {
      n2 = 0.0;
    } else {
      t2 *= t2;
      n2 = t2 * t2 * gi2.dot3(x2, y2, z2);
    }
    double t3 = 0.5 - x3 * x3 - y3 * y3 - z3 * z3;
    if(t3 < 0) {
      n3 = 0.0;
    } else {
      t3 *= t3;
      n3 = t3 * t3 * gi3.dot3(x3, y3, z3);
    }
    // Add contributions from each corner to get the final noise value.
    // The result is scaled to return values in the interval [-1,1].
    return 32 * (n0 + n1 + n2 + n3);
  }
}