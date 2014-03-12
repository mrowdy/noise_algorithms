import 'dart:html';
import 'dart:math';
import 'dart:async';

import 'package:noise/noise.dart';

int width = 500;
int height = 500;
double depth = 0.0;

Element body = querySelector('body');
CanvasElement canvas = new CanvasElement(width: width, height: height);
CanvasRenderingContext2D ctx = canvas.getContext('2d');

ImageData imgd = ctx.createImageData(width, height);
List<int> data = imgd.data;

Random rand = new Random();
Simplex3 simplex = new Simplex3(rand.nextInt(100));

void main() {

  window.animationFrame.then((_) => update());
  body.append(canvas);

}

void update(){

  int start = new DateTime.now().millisecondsSinceEpoch;

  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      double value = simplex.noise(x / 100, y / 100, depth).abs();
      value *= 256;

      int intvalue = value.toInt();

      int cell = (x + y * canvas.width) * 4;
      data[cell] = data[cell + 1] = data[cell + 2] = intvalue;
      data[cell + 2] += max(0, (25 - intvalue) * 8);
      data[cell + 3] = 255;
    }
  }

  depth += 0.05;

  int end = new DateTime.now().millisecondsSinceEpoch;

  ctx..putImageData(imgd, 20, 20)
     ..font = '16px sans-serif'
     ..fillStyle = '#ff0000'
     ..textAlign = 'center'
     ..fillText('Rendered in ${end - start} ms',
         canvas.width / 2, canvas.height - 20);

  window.animationFrame.then((_) => update());
}