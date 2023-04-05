import 'package:usage/usage.dart';
class UsageData {
  String appName;
  Duration usageDuration;

  UsageData({required this.appName, required this.usageDuration});

  Map<String, dynamic> toMap() {
    return {
      'appName': appName,
      'usageDuration': usageDuration.inSeconds, // süreyi saniye cinsinden kaydedin
    };
  }
}