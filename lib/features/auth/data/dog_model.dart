// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parki_dog/features/auth/data/friend_model.dart';
import 'package:parki_dog/features/auth/data/unsocial_with_model.dart';
import 'package:parki_dog/features/park/data/check_in_model.dart';

class DogModel {
  final String? id;
  final String? name;
  final String? breed;
  final DateTime? dob;
  final String? weight;
  final String? gender;
  final String? photoUrl;
  String? userId;
  UnsocialWithModel? unsocialWith;
  CheckInModel? currentCheckIn;
  bool? isSafe;
  List<String> enemies;
  List<FriendModel> friends;
  String? notificationToken;

  DogModel({
    this.id,
    this.name,
    this.breed,
    this.dob,
    this.weight,
    this.gender,
    this.photoUrl,
    this.userId,
    this.unsocialWith,
    this.currentCheckIn,
    this.isSafe,
    this.enemies = const [],
    this.friends = const [],
    this.notificationToken,
  });

  DogModel copyWith({
    String? id,
    String? name,
    String? breed,
    DateTime? dob,
    String? weight,
    String? gender,
    String? photoUrl,
    String? userId,
    UnsocialWithModel? unsocialWith,
    CheckInModel? currentCheckIn,
    bool? isSafe,
    List<String>? enemies,
    List<FriendModel>? friends,
    String? notificationToken,
  }) {
    return DogModel(
      id: id ?? this.id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      dob: dob ?? this.dob,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      photoUrl: photoUrl ?? this.photoUrl,
      userId: userId ?? this.userId,
      unsocialWith: unsocialWith ?? this.unsocialWith,
      currentCheckIn: currentCheckIn ?? this.currentCheckIn,
      isSafe: isSafe ?? this.isSafe,
      enemies: enemies ?? this.enemies,
      friends: friends ?? this.friends,
      notificationToken: notificationToken ?? this.notificationToken,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'id': id,
      'name': name,
      'breed': breed,
      'dob': dob,
      'weight': weight,
      'gender': gender,
      'photoUrl': photoUrl,
      'userId': userId,
      'unsocialWith': unsocialWith?.toMap(),
      'currentCheckIn': currentCheckIn?.toMap(),
      'enemies': enemies,
      'friends': friends.map((e) => e.toFirestore()).toList(),
      'notificationToken': notificationToken,
    };
  }

  factory DogModel.fromMap(Map<String, dynamic> map) {
    return DogModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      breed: map['breed'] != null ? map['breed'] as String : null,
      dob: map['dob'] != null ? (map['dob'] as Timestamp).toDate() : null,
      weight: map['weight'] != null ? map['weight'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      unsocialWith: map['unsocialWith'] != null
          ? UnsocialWithModel.fromMap(
              map['unsocialWith'] as Map<String, dynamic>)
          : null,
      currentCheckIn: map['currentCheckIn'] != null
          ? CheckInModel.fromMap(map['currentCheckIn'] as Map<String, dynamic>)
          : null,
      enemies:
          map['enemies'] != null ? List<String>.from((map['enemies'])) : [],
      friends: map['friends'] != null
          ? List<FriendModel>.from(
              (map['friends'] as List).map((e) => FriendModel.fromFirestore(e)))
          : [],
      notificationToken: map['notificationToken'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DogModel.fromJson(String source) =>
      DogModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DogModel(id: $id, name: $name, breed: $breed, dob: $dob, weight: $weight, gender: $gender, photoUrl: $photoUrl, userId: $userId, unsocialWith: $unsocialWith)';
  }

  Map getChangedFields(DogModel original, DogModel altered) {
    final Map<String, dynamic> originalMap = original.toMap();
    final Map<String, dynamic> alteredMap = altered.toMap();

    final Map<String, dynamic> changedFields = {};

    alteredMap.forEach((key, value) {
      if (originalMap[key] != value) {
        changedFields[key] = value;
      }
    });

    return changedFields;
  }

  @override
  bool operator ==(covariant DogModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.breed == breed &&
        other.dob == dob &&
        other.weight == weight &&
        other.gender == gender &&
        other.photoUrl == photoUrl &&
        other.userId == userId &&
        other.unsocialWith == unsocialWith;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        breed.hashCode ^
        dob.hashCode ^
        weight.hashCode ^
        gender.hashCode ^
        photoUrl.hashCode ^
        userId.hashCode ^
        unsocialWith.hashCode;
  }
}
