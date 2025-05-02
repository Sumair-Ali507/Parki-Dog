// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserModel {
  final String? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? address;
  final DateTime? dob;
  final String? gender;
  final String? photoUrl;
  final List<String>? dogs;
  final String? userToken;

  UserModel({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.address,
    this.dob,
    this.gender,
    this.photoUrl,
    this.dogs,
    this.userToken,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? address,
    DateTime? dob,
    String? gender,
    String? photoUrl,
    List<String>? dogs,
    String? userToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      photoUrl: photoUrl ?? this.photoUrl,
      dogs: dogs ?? this.dogs,
      userToken: userToken ?? this.userToken,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'address': address,
      'dob': dob,
      'gender': gender,
      'photoUrl': photoUrl,
      'dogs': dogs,
      'userToken': userToken,
    };
  }

  Map<String, dynamic> toFullMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'address': address,
      'dob': dob,
      'gender': gender,
      'photoUrl': photoUrl,
      'dogs': dogs,
      'userToken': userToken,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      dob: map['dob'] != null ? (map['dob'] as Timestamp).toDate() : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      dogs: map['dogs'] != null ? List<String>.from((map['dogs'])) : null,
      userToken: map['userToken'] != null ? map['userToken'] as String : null,
    );
  }

  String toJson() => json.encode(toFullMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, firstName: $firstName, lastName: $lastName, phone: $phone, address: $address, dob: $dob, gender: $gender, photoUrl: $photoUrl, dogs: $dogs, userToken: $userToken)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.email == email &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.phone == phone &&
        other.address == address &&
        other.dob == dob &&
        other.gender == gender &&
        other.photoUrl == photoUrl &&
        other.userToken == userToken &&
        listEquals(other.dogs, dogs);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        phone.hashCode ^
        address.hashCode ^
        dob.hashCode ^
        gender.hashCode ^
        photoUrl.hashCode ^
        dogs.hashCode;
  }
}
