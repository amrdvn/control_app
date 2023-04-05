class CallLogModel {
  final String phoneNumber;
  final int duration;
  final CallType callType;
  final DateTime date;

  CallLogModel({
    required this.phoneNumber,
    required this.duration,
    required this.callType,
    required this.date,
  });

  factory CallLogModel.fromEntry(CallLog entry) {
    return CallLogModel(
      phoneNumber: entry.number ?? '',
      duration: entry.duration ?? 0,
      callType: CallTypeHelper.getCallType(entry.callType),
      date: DateTime.fromMillisecondsSinceEpoch(entry.timestamp),
    );
  }
}

enum CallType {
  incoming,
  outgoing,
  missed,
  rejected,
  blocked,
  voiceMail,
  answeredExternally,
}

class CallTypeHelper {
  static CallType getCallType(String callType) {
    switch (callType) {
      case 'INCOMING_TYPE':
        return CallType.incoming;
      case 'OUTGOING_TYPE':
        return CallType.outgoing;
      case 'MISSED_TYPE':
        return CallType.missed;
      case 'REJECTED_TYPE':
        return CallType.rejected;
      case 'BLOCKED_TYPE':
        return CallType.blocked;
      case 'VOICEMAIL_TYPE':
        return CallType.voiceMail;
      case 'ANSWERED_EXTERNALLY_TYPE':
        return CallType.answeredExternally;
      default:
        throw Exception('Unknown call type');
    }
  }
}
