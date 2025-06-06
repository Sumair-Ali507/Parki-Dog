import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

class Utils {
  static String _sessionToken = const Uuid().v4();
  static String get sessionToken => _sessionToken;
  static regenerateToken() => _sessionToken = const Uuid().v4();

  static void regenerateSessionToken() => _sessionToken = const Uuid().v4();

  static double getDistance(LatLng location1, LatLng location2) {
    return const Distance().as(LengthUnit.Meter, location1, location2);
  }

  static String getMapStyling() {
    return [
      {
        "featureType": "administrative.land_parcel",
        "elementType": "labels",
        "stylers": [
          {"visibility": "off"}
        ]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text",
        "stylers": [
          {"visibility": "off"}
        ]
      },
      {
        "featureType": "poi.business",
        "stylers": [
          {"visibility": "off"}
        ]
      },
      {
        "featureType": "poi.park",
        "stylers": [
          {"visibility": "off"}
        ]
      },
      {
        "featureType": "road",
        "elementType": "labels.icon",
        "stylers": [
          {"visibility": "off"}
        ]
      },
      {
        "featureType": "road.local",
        "elementType": "labels",
        "stylers": [
          {"visibility": "off"}
        ]
      },
      {
        "featureType": "transit",
        "stylers": [
          {"visibility": "off"}
        ]
      }
    ].toString();
  }

  static int getRadiusFromBounds(gmaps.LatLngBounds bounds) {
    return const Distance().as(
          LengthUnit.Meter,
          LatLng(bounds.northeast.latitude, bounds.northeast.longitude),
          LatLng(bounds.northeast.latitude, bounds.southwest.longitude),
        ) ~/
        2;
  }

  static LatLng gmapsLatLngToLatLng2(gmaps.LatLng latLng) {
    return LatLng(latLng.latitude, latLng.longitude);
  }

  static Map<String, double> geoPointToMap(GeoPoint geoPoint) {
    return {
      'latitude': geoPoint.latitude,
      'longitude': geoPoint.longitude,
    };
  }

  // static GeoPoint geoPointFromJson(String source) {
  //   var map = json.decode(source) as Map<String, dynamic>;
  //   return GeoPoint(map['latitude'] as double, map['longitude'] as double);
  // }

  static LatLng latlngFromMap(Map source) {
    return LatLng(source['latitude'] as double, source['longitude'] as double);
  }

  static DateTime timeOfDayToDateTime(TimeOfDay timeOfDay) {
    DateTime now = DateTime.now();
    if (now.hour > timeOfDay.hour) now = now.add(const Duration(days: 1));
    return DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  }

  static TimeOfDay dateTimeToTimeOfDay(DateTime dateTime) {
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  static StreamTransformer transformer<T>(T Function(Map<String, dynamic> json) fromJson) =>
      StreamTransformer<QuerySnapshot, List<T>>.fromHandlers(
        handleData: (QuerySnapshot data, EventSink<List<T>> sink) {
          final snaps = data.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
          final users = snaps.map((json) => fromJson(json)).toList();

          sink.add(users);
        },
      );
}
