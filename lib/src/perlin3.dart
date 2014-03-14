part of noise_algorithms;

class Perlin3 extends ANoise {

  Perlin3([int seed = 0]){
    _seed(seed);
  }

  double noise(double x, double y, double z) {

    // Find unit grid cell containing point
    int X = x.floor();
    int Y = y.floor();
    int Z = z.floor();

    // Get relative xy coordinates of point within that cell
    x = x - X;
    y = y - Y;
    z = z - Z;

    // Wrap the integer cells at 255 (smaller integer period can be introduced here)
    X = X & 255;
    Y = Y & 255;
    Z = Z & 255;

    // Calculate noise contributions from each of the eight corners
    var n000 = _gradP[X+  _perm[Y+  _perm[Z  ]]].dot3(x,   y,     z);
    var n001 = _gradP[X+  _perm[Y+  _perm[Z+1]]].dot3(x,   y,   z-1);
    var n010 = _gradP[X+  _perm[Y+1+_perm[Z  ]]].dot3(x,   y-1,   z);
    var n011 = _gradP[X+  _perm[Y+1+_perm[Z+1]]].dot3(x,   y-1, z-1);
    var n100 = _gradP[X+1+_perm[Y+  _perm[Z  ]]].dot3(x-1,   y,   z);
    var n101 = _gradP[X+1+_perm[Y+  _perm[Z+1]]].dot3(x-1,   y, z-1);
    var n110 = _gradP[X+1+_perm[Y+1+_perm[Z  ]]].dot3(x-1, y-1,   z);
    var n111 = _gradP[X+1+_perm[Y+1+_perm[Z+1]]].dot3(x-1, y-1, z-1);

    // Compute the fade curve value for x, y, z
    var u = _fade(x);
    var v = _fade(y);
    var w = _fade(z);

    // Interpolate
    return _lerp(
      _lerp(
        _lerp(n000, n100, u),
        _lerp(n001, n101, u), w),
      _lerp(
        _lerp(n010, n110, u),
        _lerp(n011, n111, u), w),
      v);
  }
}