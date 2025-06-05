// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ParkPreferencesKeyModel {
  final String id;
  final Map<String, double> location;
  ParkPreferencesKeyModel({
    required this.id,
    required this.location,
  });

  ParkPreferencesKeyModel copyWith({
    String? id,
    Map<String, double>? location,
  }) {
    return ParkPreferencesKeyModel(
      id: id ?? this.id,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'location': location,
    };
  }

  factory ParkPreferencesKeyModel.fromMap(Map<String, dynamic> map) {
    return ParkPreferencesKeyModel(
      id: map['id'] as String,
      location: Map<String, double>.from(map['location'] as Map),
    );
  }

  String toJson() => json.encode(toMap());

  factory ParkPreferencesKeyModel.fromJson(String source) =>
      ParkPreferencesKeyModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ParkPreferencesKeyModel(id: $id, location: $location)';

  @override
  bool operator ==(covariant ParkPreferencesKeyModel other) {
    if (identical(this, other)) return true;

    return other.id == id && mapEquals(other.location, location);
  }

  @override
  int get hashCode => id.hashCode ^ location.hashCode;
}
