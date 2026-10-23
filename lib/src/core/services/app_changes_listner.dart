import 'package:flutter/material.dart';

import 'apps_api.g.dart';

@Deprecated("This is not working properly. Check git issue #13")
class AppChangeListener implements AppChangeCallback {
  const AppChangeListener(this.onChanged);

  final Function(String pkg, String event) onChanged;

  @override
  void onAppChanged(String packageName, String eventType) async {
    debugPrint("App event: $eventType for package: $packageName");
    onChanged(packageName, eventType);
  }
}
