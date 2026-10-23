import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/core/services/screen_lock_api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/app/src/main/kotlin/com/example/waqt/ScreenLockApi.g.kt',
    kotlinOptions: KotlinOptions(
      package: 'com.example.waqt',
      errorClassName: 'ScreenLockError',
    ),
  ),
)
@HostApi()
abstract class ScreenLockApi {
  bool checkLockPermission();
  void lockScreen();
  void lockScreenAdmin();
  void requestLockPermission();
  void openAccessibilitySettings();
}
