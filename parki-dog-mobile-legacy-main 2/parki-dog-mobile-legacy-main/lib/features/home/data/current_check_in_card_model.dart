// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:parki_dog/features/auth/data/dog_model.dart';

class CurrentCheckInCardModel {
  final String parkName;
  final String parkId;
  final DateTime leaveTime;
  final List<DogModel> checkedInDogs;

  CurrentCheckInCardModel({
    required this.parkName,
    required this.parkId,
    required this.leaveTime,
    required this.checkedInDogs,
  });

  CurrentCheckInCardModel copyWith({
    String? parkName,
    String? parkId,
    DateTime? leaveTime,
    List<DogModel>? checkedInDogs,
  }) {
    return CurrentCheckInCardModel(
      parkName: parkName ?? this.parkName,
      parkId: parkId ?? this.parkId,
      leaveTime: leaveTime ?? this.leaveTime,
      checkedInDogs: checkedInDogs ?? this.checkedInDogs,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'parkName': parkName,
      'parkId': parkId,
      'leaveTime': leaveTime.millisecondsSinceEpoch,
      'checkedInDogs': checkedInDogs.map((x) => x.toMap()).toList(),
    };
  }

  factory CurrentCheckInCardModel.fromMap(Map<String, dynamic> map) {
    return CurrentCheckInCardModel(
      parkName: map['parkName'] as String,
      parkId: map['parkId'] as String,
      leaveTime: DateTime.fromMillisecondsSinceEpoch(map['leaveTime'] as int),
      checkedInDogs: List<DogModel>.from(
        (map['checkedInDogs'] as List<int>).map<DogModel>(
          (x) => DogModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CurrentCheckInCardModel.fromJson(String source) =>
      CurrentCheckInCardModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CurrentCheckInCardModel(parkName: $parkName, parkId: $parkId, leaveTime: $leaveTime, checkedInDogs: $checkedInDogs)';
  }

  @override
  bool operator ==(covariant CurrentCheckInCardModel other) {
    if (identical(this, other)) return true;

    return other.parkName == parkName &&
        other.parkId == parkId &&
        other.leaveTime == leaveTime &&
        listEquals(other.checkedInDogs, checkedInDogs);
  }

  @override
  int get hashCode {
    return parkName.hashCode ^
        parkId.hashCode ^
        leaveTime.hashCode ^
        checkedInDogs.hashCode;
  }
}
