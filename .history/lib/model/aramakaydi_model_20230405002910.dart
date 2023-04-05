import 'package:call_log/call_log.dart';

class CallLogModel {
  String name;
  String number;
  String date;
  String duration;
  CallType callType;

  CallLogModel({
   required this.name,
   required this.number,
   required this.date,
   required this.duration,
   required this.callType,
  });

  static Future<List<CallLogModel>> getCallLogs() async {
    Iterable<CallLogEntry> entries = await CallLog.get();
    List<CallLogModel> callLogs = [];

    entries.forEach((entry) {
      String name = entry.this.name;
      String number = entry.number;
      String date = DateTime.fromMillisecondsSinceEpoch(entry.timestamp).toString();
      String duration = entry.duration.toString();
      CallType callType = entry.callType;

      CallLogModel callLog = CallLogModel(
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
