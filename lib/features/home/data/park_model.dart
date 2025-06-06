// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:parki_dog/features/home/data/app_location.dart';

import '../../park/data/check_in_model.dart';
import '../../park/data/single_park_model.dart';

class ParkModel {
  String? id;
  final String? name;
  AppLocation? location1;
  final GeoPoint? location;
  String? photoUrl;
  String? photoReference;
  List<CheckInModel>? currentCheckins;
  List<Reviews>? reviews;
  double? rating;
  int? userRatingsTotal;
  int numberOfDogs;

  ParkModel({
    this.id,
    this.name,
    this.location1,
    this.location,
    this.photoUrl,
    this.photoReference,
    this.currentCheckins,
    this.reviews,
    this.rating,
    this.userRatingsTotal,
    this.numberOfDogs = 0,
  });

  ParkModel copyWith({
    String? id,
    String? name,
    AppLocation? location1,
    GeoPoint? location,
    String? photoUrl,
    String? photoReference,
    List<CheckInModel>? currentCheckins,
    List<Reviews>? reviews,
    double? rating,
    int? userRatingsTotal,
    int? numberOfDogs,
  }) {
    return ParkModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location1: location1 ?? this.location1,
      location: location ?? this.location,
      photoUrl: photoUrl ?? this.photoUrl,
      photoReference: photoReference ?? this.photoReference,
      currentCheckins: currentCheckins ?? this.currentCheckins,
      reviews: reviews ?? this.reviews,
      rating: rating ?? this.rating,
      userRatingsTotal: userRatingsTotal ?? this.userRatingsTotal,
      numberOfDogs: numberOfDogs ?? this.numberOfDogs,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'location1': location1,
      'location': location,
      'photoUrl': photoUrl,
      'photoReference': photoReference,
      'currentCheckins': currentCheckins?.map((x) => x.toMap()).toList(),
      'reviews': reviews?.map((x) => x.toJson()).toList(),
      'rating': rating,
      'userRatingsTotal': userRatingsTotal,
      'numberOfDogs': numberOfDogs,
    };
  }

  factory ParkModel.fromMap(Map<String, dynamic> map) {
    return ParkModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      location1: map['location1'] != null
          ? AppLocation.fromJson(map['location1'] as Map<String, dynamic>)
          : null,
      location: map['location'] != null ? (map['location'] as GeoPoint) : null,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      photoReference: map['photoReference'] != null
          ? map['photoReference'] as String
          : null,
      currentCheckins: map['currentCheckins'] != null
          ? List<CheckInModel>.from(
        (map['currentCheckins'] as List).map<CheckInModel>(
              (x) => CheckInModel.fromMap(x as Map<String, dynamic>),
        ),
      )
          : null,
      reviews: map['reviews'] != null
          ? List<Reviews>.from(
        (map['reviews'] as List).map<Reviews>(
              (x) => Reviews.fromJson(x as Map<String, dynamic>),
        ),
      )
          : null,
      rating: map['rating'] != null ? map['rating'] as double : null,
      userRatingsTotal: map['userRatingsTotal'] != null
          ? map['userRatingsTotal'] as int
          : null,
      numberOfDogs: map['numberOfDogs'] != null ? map['numberOfDogs'] as int : 0,
    );
  }

  factory ParkModel.fromGMaps(Map<String, dynamic> map) {
    return ParkModel(
      id: map['place_id'] != null ? map['place_id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      location: map['geometry']['location'] != null
          ? GeoPoint(map['geometry']['location']['lat'],
          map['geometry']['location']['lng'])
          : null,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      photoReference: (map['photos'] as List?)?.firstOrNull?['photo_reference'],
      rating: map['rating']?.toDouble(),
      userRatingsTotal: map['user_ratings_total'] != null
          ? map['user_ratings_total'] as int
          : null,
    );
  }

  factory ParkModel.fromMapbox(Map<String, dynamic> map) {
    return ParkModel(
      id: map['properties']['mapbox_id'] != null
          ? map['properties']['mapbox_id'] as String
          : null,
      name: map['properties']['name'] != null
          ? map['properties']['name'] as String
          : null,
      location: map['properties']['coordinates'] != null
          ? GeoPoint(map['properties']['coordinates']['latitude'],
          map['properties']['coordinates']['longitude'])
          : null,
    );
  }

  String toJson() {
    var map = toMap();
    if (location != null) {
      map['location'] = {
        'latitude': location!.latitude,
        'longitude': location!.longitude
      };
    }
    return json.encode(map);
  }

  factory ParkModel.fromJson(String source) {
    var map = json.decode(source) as Map<String, dynamic>;
    if (map['location'] != null) {
      map['location'] = GeoPoint(
          map['location']['latitude'] as double,
          map['location']['longitude'] as double);
    }
    if (map['currentCheckins'] != null) {
      map['currentCheckins'] = (map['currentCheckins'] as List)
          .map((x) => x is String ? json.decode(x) : x)
          .toList();
    }
    if (map['reviews'] != null) {
      map['reviews'] = (map['reviews'] as List)
          .map((x) => x is String ? json.decode(x) : x)
          .toList();
    }
    return ParkModel.fromMap(map);
  }

  @override
  String toString() {
    return 'ParkModel(id: $id, name: $name, location1: $location1, location: $location, photoUrl: $photoUrl, currentCheckins: $currentCheckins, reviews: $reviews, rating: $rating, userRatingsTotal: $userRatingsTotal, numberOfDogs: $numberOfDogs)';
  }

  @override
  bool operator ==(covariant ParkModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.location1 == location1 &&
        other.location == location &&
        other.photoUrl == photoUrl &&
        listEquals(other.currentCheckins, currentCheckins) &&
        listEquals(other.reviews, reviews) &&
        other.rating == rating &&
        other.userRatingsTotal == userRatingsTotal &&
        other.numberOfDogs == numberOfDogs;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    location1.hashCode ^
    location.hashCode ^
    photoUrl.hashCode ^
    currentCheckins.hashCode ^
    reviews.hashCode ^
    rating.hashCode ^
    userRatingsTotal.hashCode ^
    numberOfDogs.hashCode;
  }
}