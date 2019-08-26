import 'package:flutter/material.dart';
import 'package:particles/helper_dialog.dart';
import 'package:particles/particles.dart';

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
  bool inputHasCenterMass = false;
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

            // Has center mass?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                HelperDialog(
                    text: "By default, all points will be created with equal weigh. " +
                        "Enabling this option will create a single point at the " +
                        "center of the viewport with a unique mass (see next option)."),
                Text("Has center mass?: "),
                Spacer(flex: 1),
                Checkbox(
                  value: inputHasCenterMass,
                  onChanged: (bool value) {
                    setState(() {
                      inputHasCenterMass = value;
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
                      color: inputHasCenterMass
                          ? Colors.black
                          : Theme.of(context).primaryColorDark.withAlpha(0x52)),
                ),
                Spacer(flex: 1),
                Slider(
                  value: inputCenterMass,
                  min: 1.0,
                  max: 100.0,
                  onChanged: inputHasCenterMass
                      ? (double value) {
                          setState(() {
                            inputCenterMass = value;
                          });
                        }
                      : null,
                  label: "${inputCenterMass.toInt()}",
                  divisions: 99,
                ),
              ],
            ),

            // Speed of animation.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                HelperDialog(
                  text: "Defines how fast the animation runs. In terms of the " +
                      "calculations, this is a multiplier on how much force each " +
                      "point applies on each other one.",
                ),
                Text("Speed: "),
                Spacer(flex: 1),
                Slider(
                  value: inputSpeed,
                  min: 0.005,
                  max: 0.1,
                  onChanged: (double value) {
                    setState(() {
                      inputSpeed = value;
                    });
                  },
                  label: "${(inputSpeed * 100).toStringAsFixed(1)}",
                  divisions: 19,
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
                    useCenterMass: inputHasCenterMass,
                    centerMassWeight: inputCenterMass,
                    speed: inputSpeed,
                  ),
                ));
              },
            )
          ],
        ),
      ),
    );
  }
}


