# Particle Simulation

## Summary
A Flutter project that uses explicit animations in a simple simulation of particles. The particles' movement is roughly based on the classic ["N-Body" problem](https://en.wikipedia.org/wiki/N-body_simulation), in which each one exerts an attractive force on each other one inversely proportional to their distance apart.

Roughly speaking, the force calculation is [Newton's law of universal gravitation](https://en.wikipedia.org/wiki/Newton%27s_law_of_universal_gravitation). From there, some liberties are taken with how it affects velocity (let's be honest: so that I don't have to remember calculus). As an additional simplification, this simulation is only 2-dimensional!

## Flutter
The main body of the simulation is a [Stack](https://api.flutter.dev/flutter/widgets/Stack-class.html), and each particle widget is wrapped in [Positioned](https://api.flutter.dev/flutter/widgets/Positioned-class.html) to represent an x,y coordinate system.

The movement is controlled by an explicit animation. Each particle is has its own [Animatable](https://api.flutter.dev/flutter/animation/Animatable-class.html) (the super-class of Tween), and all operate with the same controller.

On every frame/tick, the Animatable performs the calculation of what every particle widget's new velocity should be, and updates their locations appropriately. 

## Disclaimers
This implementation makes no attempt at using correct math nor any of the known n-body optimizations. As such, it is an O(n<sup>2</sup>) calculation on every frame. 

This project was also used as a platform for myself to learn more Flutter things. Nothing here should be taken as recommendations or best practices.
