// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class FriendModel extends Equatable {
  final String id;
  String status;

  @override
  List<Object?> get props => [id, status];

  FriendModel({
    required this.id,
    required this.status,
  });

  FriendModel copyWith({
    String? id,
    String? status,
  }) {
    return FriendModel(
      id: id ?? this.id,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'status': status,
    };
  }

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      id: status,
    };
  }

  factory FriendModel.fromMap(Map<String, dynamic> map) {
    return FriendModel(
      id: map['id'] as String,
      status: map['status'] as String,
    );
  }

  factory FriendModel.fromFirestore(Map<String, dynamic> map) {
    return FriendModel(
      id: map.keys.first,
      status: map.values.first as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FriendModel.fromJson(String source) =>
      FriendModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'FriendModel(id: $id, status: $status)';

  @override
  bool operator ==(covariant FriendModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.status == status;
  }

  @override
  int get hashCode => id.hashCode ^ status.hashCode;
}
