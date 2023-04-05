import 'package:call_log/call_log.dart';

class CallLog {
  final String phoneNumber;
  final int duration;
  final String callType;
  final DateTime date;

  CallLog({
    required this.phoneNumber,
    required this.duration,
    required this.callType,
    required this.date,
  });

  factory CallLog.fromCallLogEntry(CallLogEntry entry) {
    return CallLog(
      phoneNumber: entry.number,
      duration: entry.duration,
      callType: entry.callType,
      date: DateTime.fromMillisecondsSinceEpoch(entry.timestamp),
    );
  }
}
