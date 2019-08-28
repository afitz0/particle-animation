import 'package:flutter/material.dart';
import 'package:particles/particles.dart';

class HolyCow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPressStart: (tapDetails) {
        print("moo 🐮");
      },
      onLongPress: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Particles(
            numParticles: 200,
            seconds: 60,
            useCenterMass: true,
            centerMassWeight: 10,
            speed: 0.05,
            mass: 1,
            isCowLevel: true,
          ),
        ));
      },
      child: SizedBox(
        height: 36,
        width: 88,
      ),
    );
  }
}
