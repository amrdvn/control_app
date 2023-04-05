class CallLog {
  final String number;
  final int duration;
  final DateTime dateTime;

  CallLog({required this.number, required this.duration, required this.dateTime});

  static requestPermission() {}
}
