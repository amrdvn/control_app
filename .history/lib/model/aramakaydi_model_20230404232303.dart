import 'package:call_log/call_log.dart';

class CallLogModel {
  final String phoneNumber;
  final int duration;
  final int callType;
  final DateTime date;

  CallLogModel({
    required this.phoneNumber,
    required this.duration,
    required this.callType,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'duration': duration,
      'callType': callType,
      'date': date,
    };
  }

  factory CallLogModel.fromMap(Map<String, dynamic> map) {
    return CallLogModel(
      phoneNumber: map['phoneNumber'],
      duration: map['duration'],
      callType: map['callType'],
      date: map['date'].toDate(),
    );
  }

  static Future<List<CallLogModel>> getLastCalls({int limit = 5}) async {
    final Iterable<CallLogEntry> entries =
        await CallLog.query(name: limit, sortBy: SortType.date);

    return entries
        .map((entry) => CallLogModel(
              phoneNumber: entry.number,
              duration: entry.duration,
              callType: entry.callType,
              date: DateTime.fromMillisecondsSinceEpoch(entry.timestamp),
            ))
        .toList();
  }
}
