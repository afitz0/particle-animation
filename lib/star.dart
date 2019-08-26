import 'dart:math';

class Star {
  double _mass;
  Point<double> _velocity;
  Point<double> _location;

  double get mass => _mass;

  set mass(double mass) {
    _mass = mass;
  }

  Point<double> get location => _location;

  set location(Point<double> location) {
    _location = location;
  }

  Point<double> get velocity => _velocity;

  set velocity(Point<double> velocity) {
    _velocity = velocity;
  }
}
