import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:particles/star.dart';
import 'package:particles/helper_dialog.dart';

/* I know having globals like this is awful. TODO: learn how to do it right */

List<Star> stars;

const double viewportSize = 400;
// const int numStars = 100;
const double mass = 1;

/// pixel distance at which force won't apply
const int shield = 1;

/// Constant to control how stong the force is. Higher effectively means faster.
const double gravConstant = 2;

/// Size of the star icon
const double starSize = 18.0;

/// Speed.
const double speed = 0.75;

// void main() => runApp(MyApp());
void main() => runApp(MaterialApp(
      title: "Particle Demo",
      home: Config(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    ));

class Config extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ConfigState();
}

class ConfigState extends State<Config> {
  double countMax = 500;
  double countMin = 1;

  double durationMin = 1;
  double durationMax = 60;

  double inputNumberParticles = 100;
  double inputDurationSeconds = 20;
  bool hasCenterMass = false;
  double centerMassMass = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Particle Demo"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Creates an animation that ..."),

            // Point quantity?
            Row(
              children: <Widget>[
                HelperDialog(
                    text: "\"Number of points\" controls how many stars are on-screen. " +
                        "The force calculation is an O(n²) algorithm, so things will " +
                        "slow down quickly. Anecdotally, ~1,000 is the max for a " +
                        "reasonable animation."),
                Text("Number of points: "),
                Slider(
                  value: inputNumberParticles,
                  min: countMin,
                  max: countMax,
                  onChanged: (double value) {
                    setState(() {
                      inputNumberParticles = value;
                    });
                  },
                  label: "${inputNumberParticles.toInt()}",
                  divisions: (countMax - 1).toInt(),
                ),
              ],
            ),

            // Duration?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                HelperDialog(
                    text: "How long should the animation last. Unit: seconds."),
                Text("Duration (seconds): "),
                Slider(
                  value: inputDurationSeconds,
                  min: durationMin,
                  max: durationMax,
                  onChanged: (double value) {
                    setState(() {
                      inputDurationSeconds = value;
                    });
                  },
                  label: "${inputDurationSeconds.toInt()}",
                  divisions: (durationMax-1).toInt(),
                ),
              ],
            ),

            // Check center mass?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                HelperDialog(
                    text: "By default, all points will be created with equal weigh. " +
                        "Enabling this option will create a single point at the " +
                        "center of the viewport with a unique mass (see next option)."),
                Text("Has center mass?: "),
                Checkbox(
                  value: hasCenterMass,
                  onChanged: (bool value) {
                    setState(() {
                      hasCenterMass = value;
                    });
                  },
                )
              ],
            ),

            // Mass of center mass?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                HelperDialog(
                  text: "Weight of the center mass, if enabled. Anecdotally," +
                      "a higher value results in more chaos.",
                ),
                Text(
                  "Center mass's mass?: ",
                  style: TextStyle(
                      color: hasCenterMass
                          ? Colors.black
                          : Theme.of(context).primaryColorDark.withAlpha(0x52)),
                ),
                Slider(
                  value: centerMassMass,
                  min: 1.0,
                  max: 100.0,
                  onChanged: hasCenterMass
                      ? (double value) {
                          setState(() {
                            centerMassMass = value;
                          });
                        }
                      : null,
                  label: "${centerMassMass.toInt()}",
                  divisions: 99,
                ),
              ],
            ),

            // Go button
            RaisedButton(
              child: Text("Go"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Particles(
                          numParticles: inputNumberParticles.floor(),
                          seconds: inputDurationSeconds.floor(),
                          useCenterMass: hasCenterMass,
                          centerMassWeight: centerMassMass,
                        )));
              },
            )
          ],
        ),
      ),
    );
  }
}

class Particles extends StatefulWidget {
  final int numParticles;
  final int seconds;
  final double centerMassWeight;
  final bool useCenterMass;

  const Particles(
      {Key key,
      this.numParticles,
      this.seconds,
      this.centerMassWeight,
      this.useCenterMass})
      : super(key: key);

  @override
  ParticlesState createState() => ParticlesState();
}

class ParticlesState extends State<Particles>
    with SingleTickerProviderStateMixin {
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
        ..velocity = Point(0, 0);
    }

    for (int i = widget.useCenterMass ? 1 : 0; i < widget.numParticles; i++) {
      stars[i] = Star()
        ..mass = mass
        ..location = Point(random.nextDouble() * viewportSize,
            random.nextDouble() * viewportSize)
        ..velocity = Point(0, 0);
    }

    controller = AnimationController(
      duration: Duration(seconds: widget.seconds),
      vsync: this,
    );

    animations = List.generate(widget.numParticles, (index) {
      return MyAnimatable(id: index, numStars: widget.numParticles)
          .animate(controller);
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = List.generate(widget.numParticles, (index) {
      return AnimatedStar(animation: animations[index], id: index);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.numParticles} Particles"),
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
                          "Duration (seconds): ${widget.numParticles}",
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
      left: animation.value.x,
      bottom: animation.value.y,
    );
  }
}

class MyAnimatable extends Animatable<Point<double>> {
  final int id;
  final int numStars;

  MyAnimatable({this.id, this.numStars});

  // As I understand it, transform is given (nominally), the % through the animation that we are.
  @override
  Point<double> transform(double t) {
    Point currentLocation = stars[id].location;

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
