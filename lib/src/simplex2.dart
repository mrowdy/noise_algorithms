part of noise_algorithms;

class Simplex2 extends ANoise {

  Simplex2([int seed = 0]){
    _seed(seed);
  }

  double noise(double x, double y){
    double n0, n1, n2; // Noise contributions from the three corners

    // Skew the input space to determine which simplex cell we're in
    double s = (x + y) * _F2; // Hairy factor for 2D
    int i = (x + s).floor();
    int j = (y + s).floor();

    double t = (i+j)*_G2;
    double x0 = x - i + t; // The x,y distances from the cell origin, unskewed.
    double y0 = y - j + t;

    // For the 2D case, the simplex shape is an equilateral triangle.
    // Determine which simplex we are in.
    int i1, j1;   // Offsets for second (middle) corner of simplex in (i,j) coords
    if(x0 > y0) { // lower triangle, XY order: (0,0)->(1,0)->(1,1)
      i1=1; j1=0;
    } else {      // upper triangle, YX order: (0,0)->(0,1)->(1,1)
      i1=0; j1=1;
    }

    // A step of (1,0) in (i,j) means a step of (1-c,-c) in (x,y), and
    // a step of (0,1) in (i,j) means a step of (-c,1-c) in (x,y), where
    // c = (3-sqrt(3))/6
    double x1 = x0 - i1 + _G2; // Offsets for middle corner in (x,y) unskewed coords
    double y1 = y0 - j1 + _G2;
    double x2 = x0 - 1 + 2 * _G2; // Offsets for last corner in (x,y) unskewed coords
    double y2 = y0 - 1 + 2 * _G2;

    // Work out the hashed gradient indices of the three simplex corners
    i &= 255;
    j &= 255;
    Grad gi0 = _gradP[i + _perm[j]];
    Grad gi1 = _gradP[i + i1 + _perm[j + j1]];
    Grad gi2 = _gradP[i + 1 + _perm[j + 1]];

    // Calculate the contribution from the three corners
    double t0 = 0.5 - x0 * x0 - y0 * y0;
    if(t0 < 0) {
      n0 = 0.0;
    } else {
      t0 *= t0;
      n0 = t0 * t0 * gi0.dot2(x0, y0);  // (x,y) of grad3 used for 2D gradient
    }
    double t1 = 0.5 - x1 * x1 - y1 * y1;
    if(t1 < 0) {
      n1 = 0.0;
    } else {
      t1 *= t1;
      n1 = t1 * t1 * gi1.dot2(x1, y1);
    }
    double t2 = 0.5 - x2 * x2 - y2 * y2;
    if(t2 < 0) {
      n2 = 0.0;
    } else {
      t2 *= t2;
      n2 = t2 * t2 * gi2.dot2(x2, y2);
    }

    // Add contributions from each corner to get the final noise value.
    // The result is scaled to return values in the interval [-1,1].
    return 70 * (n0 + n1 + n2);
  }
}