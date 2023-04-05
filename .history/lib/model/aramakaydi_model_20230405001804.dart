class CallLogModel {
  String number;
  int duration;
  int timestamp;
  final DateTime date;

  CallLogModel({
    required this.number,
    required this.duration,
    required this.timestamp,
  });
}
