class AppUsageInfo {
  String packageName;
  String? appName;
  int totalTimeInForeground;
  int lastTimeUsed;

  AppUsageInfo(
      {required this.packageName,
      required this.appName,
      required this.totalTimeInForeground,
      required this.lastTimeUsed});

  Map<String, dynamic> toMap() {
    return {
      'packageName': packageName,
      'appName': appName,
      'totalTimeInForeground': totalTimeInForeground,
      'lastTimeUsed': lastTimeUsed
    };
  }
}