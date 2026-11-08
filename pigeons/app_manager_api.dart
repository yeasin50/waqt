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

class InstalledWidget {
  InstalledWidget({
    required this.label,
    required this.packageName,
    required this.className,
    required this.minWidth,
    required this.minHeight,
    required this.previewImage,
    required this.icon,
  });

  String label;
  String packageName;
  String className;
  int minWidth;
  int minHeight;

  Uint8List? previewImage;
  Uint8List? icon;
}

// Dart calling Kotlin (Commands)
@HostApi()
abstract class AppManagerApi {
  String getAppPackageName();
  List<InstalledWidget> getInstalledWidgets();
  int addWidget(String packageName, String className);

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
