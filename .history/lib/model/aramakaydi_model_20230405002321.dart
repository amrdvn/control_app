import 'package:call_log/call_log.dart';

class CallLog {
  String name;
  String number;
  String date;
  String duration;
  CallType callType;

  CallLog({
    this.name,
    this.number,
    this.date,
    this.duration,
    this.callType,
  });

  static Future<List<CallLog>> getCallLogs() async {
    Iterable<CallLogEntry> entries = await CallLog.get();
    List<CallLog> callLogs = [];

    entries.forEach((entry) {
      String name = entry.name;
      String number = entry.number;
      String date = DateTime.fromMillisecondsSinceEpoch(entry.timestamp).toString();
      String duration = entry.duration.toString();
      CallType callType = entry.callType;

      CallLog callLog = CallLogModel(
        name: name,
        number: number,
        date: date,
        duration: duration,
        callType: callType,
      );

      callLogs.add(callLog);
    });

    return callLogs;
  }
}

enum CallType { incoming, outgoing, missed, rejected }
