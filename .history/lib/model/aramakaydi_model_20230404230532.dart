import 'package:cloud_firestore/cloud_firestore.dart';

class CallLogModel {
  final String phoneNumber;
  final int duration;
  final String callType;
  final DateTime date;

  CallLogModel({
    required this.phoneNumber,
    required this.duration,
    required this.callType,
    required this.date,
  });

  factory CallLogModel.fromMap(Map<String, dynamic> data) {
    return CallLogModel(
      phoneNumber: data['phoneNumber'],
      duration: data['duration'],
      callType: data['callType'],
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'duration': duration,
      'callType': callType,
      'date': Timestamp.fromDate(date),
    };
  }
}
