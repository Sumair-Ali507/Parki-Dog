// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ParkModel {
  String? id;
  final String? name;
  final GeoPoint? location;
  String? photoUrl;
  String? photoReference;
  double? rating;
  int? userRatingsTotal;
  int numberOfDogs;
  ParkModel({
    this.id,
    this.name,
    this.location,
    this.photoUrl,
    this.photoReference,
    this.rating,
    this.userRatingsTotal,
    this.numberOfDogs = 0,
  });

  ParkModel copyWith({
    String? id,
    String? name,
    GeoPoint? location,
    String? photoUrl,
    String? photoReference,
    double? rating,
    int? userRatingsTotal,
    List<String>? checkedInDogs,
  }) {
    return ParkModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      photoUrl: photoUrl ?? this.photoUrl,
      photoReference: photoReference ?? this.photoReference,
      rating: rating ?? this.rating,
      userRatingsTotal: userRatingsTotal ?? this.userRatingsTotal,
      numberOfDogs: numberOfDogs,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'location': location,
      'photoUrl': photoUrl,
      'photoReference': photoReference,
      'rating': rating,
      'userRatingsTotal': userRatingsTotal,
      // 'numberOfDogs': numberOfDogs,
    };
  }

  factory ParkModel.fromMap(Map<String, dynamic> map) {
    return ParkModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      location: map['location'] != null ? (map['location'] as GeoPoint) : null,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      photoReference: map['photoReference'] != null
          ? map['photoReference'] as String
          : null,
      rating: map['rating'] != null ? map['rating'] as double : null,
      userRatingsTotal: map['userRatingsTotal'] != null
          ? map['userRatingsTotal'] as int
          : null,
      // checkedInDogs: map['checkedInDogs'] != null
      //     ? List<String>.from((map['checkedInDogs'] as List<String>))
      //     : null,
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
      // photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      // rating: map['rating'] != null ? map['rating'] as double : null,
      // userRatingsTotal: map['user_ratings_total'] != null
      //     ? map['user_ratings_total'] as int
      //     : null,
      // distance: map['distance'] != null ? map['distance'] as double : null,
      // checkedInDogs: map['checkedInDogs'] != null
      //     ? List<String>.from((map['checkedInDogs'] as List<String>))
      //     : null,
    );
  }

  String toJson() {
    var map = toMap();
    map['location'] = {
      'latitude': location!.latitude,
      'longitude': location!.longitude
    };
    return json.encode(map);
  }

  factory ParkModel.fromJson(String source) {
    var map = json.decode(source) as Map<String, dynamic>;
    map['location'] = GeoPoint(map['location']['latitude'] as double,
        map['location']['longitude'] as double);
    return ParkModel.fromMap(map);
  }

  @override
  String toString() {
    return 'ParkModel(id: $id, name: $name, location: $location, photoUrl: $photoUrl, rating: $rating, userRatingsTotal: $userRatingsTotal)';
  }

  @override
  bool operator ==(covariant ParkModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.location == location &&
        other.photoUrl == photoUrl &&
        other.rating == rating &&
        other.userRatingsTotal == userRatingsTotal;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        location.hashCode ^
        photoUrl.hashCode ^
        rating.hashCode ^
        userRatingsTotal.hashCode;
  }
}
