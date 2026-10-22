import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/core/services/apps_api.g.dart',
    kotlinOut: 'android/app/src/main/kotlin/com/example/waqt/AppsApi.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.example.waqt'),
  ),
)
class AppInfo {
  AppInfo({
    required this.name,
    required this.packageName,
    required this.versionName,
  });
  String name;
  String packageName;
  String versionName;
}

// Dart calling Kotlin (Commands)
@HostApi()
abstract class AppManagerApi {
  void openAppInfo(String packageName);
  bool openApp(String packageName);
  void uninstallApp(String packageName);

  bool isDefaultLauncher();
  void requestDefaultLauncher();
}

// Kotlin calling Dart (The Listener)
@FlutterApi()
abstract class AppChangeCallback {
  void onAppChanged(String packageName, String eventType);
}
