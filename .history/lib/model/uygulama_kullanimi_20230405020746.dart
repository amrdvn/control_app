class AppUsageData {
  String appName;
  double usageDuration;

  AppUsageData({required this.appName, required this.usageDuration});

  Map<String, dynamic> toMap() {
    return {
      'appName': appName,
      'usageDuration': usageDuration,
    };
  }
}
