
class UsageData {
  String appName;
  int usageTime;

  UsageData({required this.appName, required this.usageTime});

  @override
  String toString() {
    return 'UsageData{appName: $appName, usageTime: $usageTime}';
  }
}