class AppUsageInfo {
  String packageName;
  String appName;
  Duration usageDuration;
  int launchCount;

  AppUsageInfo({
    required this.packageName,
    required this.appName,
    required this.usageDuration,
    required this.launchCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'packageName': packageName,
      'appName': appName,
      'usageDuration': usageDuration.inSeconds,
      'launchCount': launchCount,
    };
  }
}
