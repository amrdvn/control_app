class BackgroundService extends BackgroundService {
  @override
  Future<void> onStart(bool startedFromBoot) async {
    // Get the `kisit` value from the locally stored file.
    File file = File('uygulama_kisit.json');
    Map<String, int> uygulamaKisitValues = json.decode(await file.readAsString());

    // Listen for application launch events.
    FirebaseMessaging.onAppLaunched.listen((RemoteMessage remoteMessage) {
      // Get the package name of the application that was launched.
      String packageName = remoteMessage.notification?.launchApp?.packageName;

      // Check the `kisit` value for the application.
      if (uygulamaKisitValues.containsKey(packageName)) {
        // If the `kisit` value is greater than 0, then the application is restricted.
        if (uygulamaKisitValues[packageName] > 0) {
          // Prevent the application from launching.
          FirebaseMessaging.preventAppLaunch();
        }
      }
    });
  }
}