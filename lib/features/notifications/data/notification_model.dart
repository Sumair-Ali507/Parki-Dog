// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NotificationModel {
  final String? title;
  final String? body;
  final String? photoUrl;
  final DateTime? sentTime;
  NotificationModel({
    this.title,
    this.body,
    this.photoUrl,
    this.sentTime,
  });

  NotificationModel copyWith({
    String? title,
    String? body,
    String? photoUrl,
    DateTime? sentTime,
  }) {
    return NotificationModel(
      title: title ?? this.title,
      body: body ?? this.body,
      photoUrl: photoUrl ?? this.photoUrl,
      sentTime: sentTime ?? this.sentTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'body': body,
      'photoUrl': photoUrl,
      'sentTime': sentTime?.millisecondsSinceEpoch,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'] != null ? map['title'] as String : null,
      body: map['body'] != null ? map['body'] as String : null,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      sentTime: map['sentTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['sentTime'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationModel(title: $title, body: $body, photoUrl: $photoUrl, sentTime: $sentTime)';
  }

  @override
  bool operator ==(covariant NotificationModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.body == body &&
        other.photoUrl == photoUrl &&
        other.sentTime == sentTime;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        body.hashCode ^
        photoUrl.hashCode ^
        sentTime.hashCode;
  }
}
