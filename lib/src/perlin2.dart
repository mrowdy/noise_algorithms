part of noise_algorithms;

class Perlin2 extends ANoise {

  Perlin2([int seed = 0]){
    _seed(seed);
  }

  double noise(double x, double y){

    // Find unit grid cell containing point
    int X = x.floor();
    int Y = y.floor();

    // Get relative xy coordinates of point within that cell
    x = x - X;
    y = y - Y;

    // Wrap the integer cells at 255 (smaller integer period can be introduced here)
    X = X & 255;
    Y = Y & 255;

    // Calculate noise contributions from each of the four corners
    double n00 = _gradP[X + _perm[Y]].dot2(x, y);
    double n01 = _gradP[X + _perm[Y + 1]].dot2(x, y - 1);
    double n10 = _gradP[X + 1 + _perm[Y]].dot2(x - 1, y);
    double n11 = _gradP[X + 1 + _perm[Y + 1]].dot2(x - 1, y - 1);

    // Compute the fade curve value for x
    double u = _fade(x);

    // Interpolate the four results
    return _lerp(
        _lerp(n00, n10, u),
        _lerp(n01, n11, u),
        _fade(y));
  }
}