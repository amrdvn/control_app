class AppUsageData {
  String appName;
  int usageDurationInMinutes;

  AppUsageData({required this.appName, required this.usageDurationInMinutes});

  Map<String, dynamic> toMap() {
    return {
      'appName': appName,
      'usageDurationInMinutes': usageDurationInMinutes,
    };
  }
}