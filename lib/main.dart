import 'package:flutter/material.dart';
import 'package:particles/helper_dialog.dart';
import 'package:particles/holy_cow.dart';
import 'package:particles/particles.dart';

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

  double speedMin = 0.005;
  double speedMax = 0.5;

  double centerMassMin = 1;
  double centerMassMax = 1000;

  double massMin = 1;
  double massMax = 1000;

  double inputNumberParticles = 100;
  double inputMass = 1;
  double inputDurationSeconds = 20;
  bool inputHasCenterObject = false;
  double inputCenterMass = 1;
  double inputSpeed = 0.05;

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                  "Creates an animation that approximates an N-Body simulation."),
            ),

            // Point quantity?
            Row(
              children: <Widget>[
                HelperDialog(
                    text: "\"Number of points\" controls how many stars are on-screen. " +
                        "The force calculation is an O(n²) algorithm, so things will " +
                        "slow down quickly. Anecdotally, ~1,000 is the max for a " +
                        "reasonable animation."),
                Text("Number of points: "),
                Spacer(flex: 1),
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

            // Point mass?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                HelperDialog(
                    text:
                        "Mass of all the particles. Higher in effect means slower."),
                Text("Particle Mass: "),
                Spacer(flex: 1),
                Slider(
                  value: inputMass,
                  min: massMin,
                  max: massMax,
                  onChanged: (double value) {
                    setState(() {
                      inputMass = value;
                    });
                  },
                  label: "${inputMass.toInt()}",
                  divisions: (massMax - massMin).toInt(),
                ),
              ],
            ),

            // Has center object?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                HelperDialog(
                    text: "By default, all points will be created with equal weigh. " +
                        "Enabling this option will create a single point at the " +
                        "center of the viewport with a unique mass (see next option)."),
                Text("Has center object?: "),
                Spacer(flex: 1),
                Checkbox(
                  value: inputHasCenterObject,
                  onChanged: (bool value) {
                    setState(() {
                      inputHasCenterObject = value;
                    });
                  },
                )
              ],
            ),

            // Mass of center object?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                HelperDialog(
                  text: "Mass of the center object, if enabled. Otherwise, its " +
                      "mass will be identical to all other particles (see Mass " +
                      "setting). The greater the difference between the center's " +
                      "mass and the rest of them, the greater \"chaos\" there will " +
                      "be.\n\nThe center object's location is fixed.",
                ),
                Text(
                  "Center object's mass?: ",
                  style: TextStyle(
                      color: inputHasCenterObject
                          ? Colors.black
                          : Theme.of(context).primaryColorDark.withAlpha(0x52)),
                ),
                Spacer(flex: 1),
                Slider(
                  value: inputCenterMass,
                  min: centerMassMin,
                  max: centerMassMax,
                  onChanged: inputHasCenterObject
                      ? (double value) {
                          setState(() {
                            inputCenterMass = value;
                          });
                        }
                      : null,
                  label: "${inputCenterMass.toInt()}",
                  divisions: (centerMassMax - centerMassMin).toInt(),
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
                Spacer(flex: 1),
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
                  divisions: (durationMax - 1).toInt(),
                ),
              ],
            ),

            // Speed of animation.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                HelperDialog(
                  text: "Defines how fast the animation runs. The speed is implemented " +
                      "as a multiplier of how much force is applied to each object.",
                ),
                Text("Speed: "),
                Spacer(flex: 1),
                Slider(
                  value: inputSpeed,
                  min: speedMin,
                  max: speedMax,
                  onChanged: (double value) {
                    setState(() {
                      inputSpeed = value;
                    });
                  },
                  label: "${(inputSpeed * 100).toStringAsFixed(1)}",
                  divisions: (speedMax - speedMin) ~/ .005,
                ),
              ],
            ),

            // Go button(s)
            Stack(
              children: <Widget>[
                
                RaisedButton(
                  child: Text("Go"),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Particles(
                        numParticles: inputNumberParticles.floor(),
                        seconds: inputDurationSeconds.floor(),
                        useCenterMass: inputHasCenterObject,
                        centerMassWeight: inputCenterMass,
                        speed: inputSpeed,
                        mass: inputMass,
                      ),
                    ));
                  },
                ),
                HolyCow(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
