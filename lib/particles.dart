import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:particles/globals.dart';
import 'package:particles/star.dart';
import 'package:particles/nbody_animator.dart';

class Particles extends StatefulWidget {
  final int numParticles;
  final int seconds;
  final double centerMassWeight;
  final bool useCenterMass;
  final double speed;
  final double mass;

  const Particles(
      {Key key,
      this.numParticles,
      this.seconds,
      this.centerMassWeight,
      this.useCenterMass,
      this.speed,
      this.mass})
      : super(key: key);

  @override
  ParticlesState createState() => ParticlesState();
}

class ParticlesState extends State<Particles>
    with SingleTickerProviderStateMixin {
  /// Used mainly to determine starting locations. I'm sure there's a better way to do this.
  final double viewportSize = 400;

  int _elapsedSeconds;

  List<Animation<Point<double>>> animations;
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    Random random = Random();

    stars = List(widget.numParticles + 1);
    if (widget.useCenterMass) {
      stars[0] = Star()
        ..mass = widget.centerMassWeight
        ..location = Point(viewportSize / 2, viewportSize / 2)
        ..velocity = Point(0, 0)
        ..isStationary = true;
    }

    for (int i = widget.useCenterMass ? 1 : 0; i < widget.numParticles; i++) {
      stars[i] = Star()
        ..mass = widget.mass
        ..location = Point(random.nextDouble() * viewportSize,
            random.nextDouble() * viewportSize)
        ..velocity = Point(0, 0);
    }

    controller = AnimationController(
      duration: Duration(seconds: widget.seconds),
      vsync: this,
    );

    animations = List.generate(widget.numParticles, (index) {
      return NBodyAnimator(
              id: index, numStars: widget.numParticles, speed: widget.speed)
          .animate(controller);
    });

    controller.forward();
    _elapsedSeconds = 0;

    const singleSecond = Duration(seconds: 1);
    Timer.periodic(singleSecond, (timer) {
      setState(() {
        if (_elapsedSeconds >= widget.seconds) {
          timer.cancel();
        } else {
          _elapsedSeconds++;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = List.generate(widget.numParticles, (index) {
      return AnimatedStar(animation: animations[index], id: index);
    });

    return Scaffold(
      appBar: AppBar(
        // title: Text("${widget.numParticles} Particles"),
        title: Text("Black Holy Cow"),
        backgroundColor: Colors.white24,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: viewportSize,
          height: viewportSize,
          child: Stack(
            overflow: Overflow.visible,
            fit: StackFit.expand,
            children: stars +
                <Widget>[
                  Positioned(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Number of stars: ${widget.numParticles}",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Duration: $_elapsedSeconds of ${widget.seconds} seconds",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    top: 5,
                    left: 5,
                  ),
                ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class AnimatedStar extends AnimatedWidget {
  AnimatedStar({Key key, Animation<Point<double>> animation, int id})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<Point<double>> animation = listenable;
    return Positioned(
      child: Icon(
        Icons.star,
        color: Colors.white,
        size: starSize,
      ),
      // TODO make this a configurable option.
      // child: Text(
      //   "🐄",
      //   style: TextStyle(fontSize: starSize),
      // ),
      left: animation.value.x,
      bottom: animation.value.y,
    );
  }
}
