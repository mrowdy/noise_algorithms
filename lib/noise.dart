/*
 * A speed-improved perlin and simplex noise algorithms for 2D.
 *
 * Based on example code by Stefan Gustavson (stegu@itn.liu.se).
 * Optimisations by Peter Eastman (peastman@drizzle.stanford.edu).
 * Better rank ordering method by Stefan Gustavson in 2012.
 * Converted to Javascript by Joseph Gentle.
 * Converted to Dart by Markus Ritberger.
 *
 * Version 2014-03-14
 *
 * This code was placed in the public domain by its original author,
 * Stefan Gustavson. You may use it as you see fit, but
 * attribution is appreciated.
 *
 */

library noise_algorithms;

import 'dart:math' show sqrt;

part 'src/grad.dart';
part 'src/anoise.dart';
part 'src/perlin2.dart';
part 'src/perlin3.dart';
part 'src/simplex2.dart';
part 'src/simplex3.dart';


