class Massage {
  final String text;
  final String timeStamp;
  final String fromId;
  Massage({
    required this.fromId,
    required this.text,
    required this.timeStamp,
  });

  factory Massage.fromMap(Map<String, dynamic> map) {
    return Massage(
      fromId: map['fromId'],
      text: map['text'],
      timeStamp: map['timeStamp'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'fromId': fromId,
      'text': text,
      'timeStamp': timeStamp,
    };
  }
}
