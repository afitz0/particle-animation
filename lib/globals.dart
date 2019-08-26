import 'package:particles/star.dart';

/* I know having globals like this is awful. TODO: learn how to do it right */

List<Star> stars;

const double mass = 1;

/// pixel distance at which force won't apply
const int shield = 0;

/// Constant to control how stong the force is. Higher effectively means faster.
/// In a "real" simulation, this would be 6.67430 * 10^−11.
const double gravConstant = .5;

/// Size of the star icon
const double starSize = 18.0;
