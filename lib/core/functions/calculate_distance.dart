import 'dart:math';

import 'package:geolocator/geolocator.dart';

import '../../features/home/data/app_location.dart';


Future<double> calculateDistance(AppLocation location) async {
  // Ensure the location object has valid coordinates
  if (location.coordinates == null || location.coordinates!.length != 2) {
    throw ArgumentError("Invalid coordinates in AppLocation.");
  }

  // Get the current location of the user
  Position currentPosition = await Geolocator.getCurrentPosition(
      locationSettings:
      const LocationSettings(accuracy: LocationAccuracy.high));

  double userLat = currentPosition.latitude;
  double userLong = currentPosition.longitude;

  double targetLat = location.coordinates![0];
  double targetLong = location.coordinates![1];

  // Calculate the distance using the Haversine formula
  const double earthRadiusKm = 6371.0;
  double dLat = _degreesToRadians(targetLat - userLat);
  double dLong = _degreesToRadians(targetLong - userLong);

  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_degreesToRadians(userLat)) *
          cos(_degreesToRadians(targetLat)) *
          sin(dLong / 2) *
          sin(dLong / 2);

  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return earthRadiusKm * c;
}

double _degreesToRadians(double degrees) {
  return degrees * pi / 180;
}
