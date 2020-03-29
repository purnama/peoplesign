import 'package:geolocator/geolocator.dart';

class People {
  final String name;
  final Position position;
  final DateTime clockIn;
  final DateTime clockOut;
  final String sugars;
  final int strength;

  People(
      {this.name,
      this.position,
      this.clockIn,
      this.clockOut,
      this.sugars,
      this.strength});
}
