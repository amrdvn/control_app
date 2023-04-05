class CallLog {
  final String number;
  final int duration;
  final DateTime dateTime;

  CallLog({required this.number, required this.duration, required this.dateTime});

  static requestPermission() {}

  static query({required int limit, required sortBy, required sortOrder}) {}
}
