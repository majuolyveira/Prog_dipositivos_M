import 'dart:math';

class Point {
  // double? x;
  // double? y;

  // Point(double x, double y) {
  //   this.x = x;
  //   this.y = y;
  // }
  final double x;
  final double y;

  Point(this.x, this.y);
  double get getx => x + 10;
  

  double distanceTo(Point other) {
    var dx = x - other.x;
    var dy = y - other.y;
    return sqrt(dx * dx + dy * dy);
  }
}

void main() {
  var p1 = Point(7, 10);
  var p2 = Point(3, 7);

  double distance = p1.distanceTo(p2);
  print(p1.getx);
}