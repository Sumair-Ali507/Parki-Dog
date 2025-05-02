// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class UnsocialWithModel {
  final List<String> breeds;
  final String? weight;
  final String weightCondition;
  final List<String> gender;

  UnsocialWithModel({
    this.breeds = const [],
    this.weight,
    this.weightCondition = '>',
    this.gender = const [],
  });

  UnsocialWithModel copyWith({
    List<String>? breeds,
    String? weight,
    String? weightCondition,
    List<String>? gender,
  }) {
    return UnsocialWithModel(
      breeds: breeds ?? this.breeds,
      weight: weight ?? this.weight,
      weightCondition: weightCondition ?? this.weightCondition,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'breeds': breeds,
      'weight': weight,
      'weightCondition': weightCondition,
      'gender': gender,
    };
  }

  factory UnsocialWithModel.fromMap(Map<String, dynamic> map) {
    return UnsocialWithModel(
      breeds: map['breeds'] != null ? List<String>.from((map['breeds'])) : [],
      weight: map['weight'] != null ? map['weight'] as String : null,
      weightCondition: map['weightCondition'] != null
          ? map['weightCondition'] as String
          : '>',
      gender: map['gender'] != null ? List<String>.from((map['gender'])) : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory UnsocialWithModel.fromJson(String source) =>
      UnsocialWithModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'UnsocialWithModel(breeds: $breeds, weight: $weight, gender: $gender)';

  @override
  bool operator ==(covariant UnsocialWithModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.breeds, breeds) &&
        other.weight == weight &&
        listEquals(other.gender, gender);
  }

  @override
  int get hashCode => breeds.hashCode ^ weight.hashCode ^ gender.hashCode;
}
