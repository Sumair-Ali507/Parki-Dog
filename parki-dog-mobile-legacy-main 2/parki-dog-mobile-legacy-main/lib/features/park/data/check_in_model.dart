// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../../auth/data/dog_model.dart';

class CheckInModel {
  final String parkId;
  final String parkName;
  final DateTime leaveTime;
  DogModel? dog;

  CheckInModel({
    required this.parkId,
    required this.parkName,
    required this.leaveTime,
    this.dog,
  });

  CheckInModel copyWith({
    String? parkId,
    String? parkName,
    DateTime? leaveTime,
    DogModel? dog,
  }) {
    return CheckInModel(
      parkId: parkId ?? this.parkId,
      parkName: parkName ?? this.parkName,
      leaveTime: leaveTime ?? this.leaveTime,
      dog: dog ?? this.dog,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'parkId': parkId,
      'parkName': parkName,
      'leaveTime': leaveTime.toUtc(),
      'dog': dog?.toMap(),
    };
  }

  factory CheckInModel.fromMap(Map<String, dynamic> map) {
    return CheckInModel(
      parkId: map['parkId'],
      parkName: map['parkName'],
      leaveTime: map['leaveTime'].toDate().toLocal(),
      dog: map['dog'] != null ? DogModel.fromMap(map['dog']) : null,

    );
  }

  String toJson() => json.encode(toMap());

  factory CheckInModel.fromJson(String source) =>
      CheckInModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CheckInModel(parkId: $parkId, parkName: $parkName, leaveTime: $leaveTime , dog: $dog)';

  @override
  bool operator ==(covariant CheckInModel other) {
    if (identical(this, other)) return true;

    return other.parkId == parkId &&
        other.dog == dog &&
        other.parkName == parkName &&
        other.leaveTime == leaveTime;


  }

  @override
  int get hashCode => parkId.hashCode ^ leaveTime.hashCode;
}
