

import 'package:parki_dog/features/account/cubit/unsociability.dart';
import 'package:parki_dog/features/home/data/app_location.dart';

class ProfileResponse {
  String? status;
  String? message;
  Profile? profile;

  ProfileResponse({this.status, this.message, this.profile});

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    profile = json['data'] != null ? Profile.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (profile != null) {
      data['data'] = profile!.toJson();
    }
    return data;
  }
}

class Profile {
  AppLocation? location;
  String? sId;
  String? firstName;
  String? lastName;
  String? email;
  String? role;
  String? phone;
  String? country;
  List<ProfileOwnedDogs>? ownedDogs;
  bool? isLoggedIn;
  bool? isVerified;
  String? id;

  Profile(
      {this.location,
      this.sId,
      this.firstName,
      this.lastName,
      this.email,
      this.role,
      this.phone,
      this.country,
      this.ownedDogs,
      this.isLoggedIn,
      this.isVerified,
      this.id});

  Profile.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? AppLocation.fromJson(json['location'])
        : null;
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    role = json['role'];
    phone = json['phone'];
    country = json['country'];
    if (json['ownedDogs'] != null) {
      ownedDogs = <ProfileOwnedDogs>[];
      json['ownedDogs'].forEach((v) {
        ownedDogs!.add(ProfileOwnedDogs.fromJson(v));
      });
    }
    isLoggedIn = json['isLoggedIn'];
    isVerified = json['isVerified'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['_id'] = sId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['role'] = role;
    data['phone'] = phone;
    data['country'] = country;
    if (ownedDogs != null) {
      data['ownedDogs'] = ownedDogs!.map((v) => v.toJson()).toList();
    }
    data['isLoggedIn'] = isLoggedIn;
    data['isVerified'] = isVerified;
    data['id'] = id;
    return data;
  }
}

class ProfileOwnedDogs {
  Unsociability? unsociability;
  String? sId;
  String? owner;
  String? name;
  String? breed;
  int? age;
  String? gender;
  int? weight;
  String? createdAt;
  String? updatedAt;

  ProfileOwnedDogs(
      {this.unsociability,
      this.sId,
      this.owner,
      this.name,
      this.breed,
      this.age,
      this.gender,
      this.weight,
      this.createdAt,
      this.updatedAt});

  ProfileOwnedDogs.fromJson(Map<String, dynamic> json) {
    unsociability = json['unsociability'] != null
        ? Unsociability.fromJson(json['unsociability'])
        : null;
    sId = json['_id'];
    owner = json['owner'];
    name = json['name'];
    breed = json['breed'];
    age = json['age'];
    gender = json['gender'];
    weight = json['weight'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (unsociability != null) {
      data['unsociability'] = unsociability!.toJson();
    }
    data['_id'] = sId;
    data['owner'] = owner;
    data['name'] = name;
    data['breed'] = breed;
    data['age'] = age;
    data['gender'] = gender;
    data['weight'] = weight;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
