import 'dart:math';

import 'package:flutter/animation.dart';

import 'package:particles/globals.dart';

class NBodyAnimator extends Animatable<Point<double>> {
  final int id;
  final int numStars;
  final double speed;

  NBodyAnimator({this.id, this.numStars, this.speed});

  // As I understand it, transform is given (nominally), the % through the animation that we are.
  @override
  Point<double> transform(double t) {
    Point currentLocation = stars[id].location;
    if (stars[id].isStationary) {
      return currentLocation;
    }

    for (int i = 0; i < numStars; i++) {
      if (i == id) continue;
      double distance = currentLocation.distanceTo(stars[i].location);
      double sqrDistance = currentLocation.squaredDistanceTo(stars[i].location);

      // Actual equation is `G * (m1 * m2) / (dist * dist)`
      // With a mass of 1, this is just `constant / squaredDistance`
      double force = (gravConstant * stars[id].mass * stars[i].mass) /
          sqrDistance; // units: newtons ((m kg) / s^2)

      double deltaV = force * speed;

      Point diff = stars[i].location - currentLocation;

      double deltaX = diff.x * deltaV;
      double deltaY = diff.y * deltaV;

      Point<double> delta = Point(deltaX, deltaY);

      // Weird things happen when things get to close together.
      if (distance >= shield) {
        stars[id].velocity += delta;
      }
    }

    stars[id].location += stars[id].velocity;
    return stars[id].location;
  }
}
