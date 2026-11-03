import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/core/services/statusbar_api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut: 'android/app/src/main/kotlin/com/example/waqt/StatusBarApi.g.kt',
    kotlinOptions: KotlinOptions(
      package: 'com.example.waqt',
      errorClassName: 'StatusBarError',
    ),
  ),
)
@HostApi()
abstract class StatusbarFlutterApi {
  void setColor(int colorValue);
}
