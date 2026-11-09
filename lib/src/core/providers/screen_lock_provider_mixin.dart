import 'package:flutter/services.dart';

import '../services/logger.dart';
import 'app_notifier.dart';

mixin ScreenLockProviderMixin on AppNotifier {
  bool _hasLockPermission = false;
  bool get hasLockPermission => _hasLockPermission;

  Future<void> checkLockPermission() async {
    _hasLockPermission = await screenLockApi.checkLockPermission();
    notifyListeners();
  }

  Future<void> lockScreen() async {
    if (!hasLockPermission) {
      if (db.preference().enableDoubleTapLock) {
        await screenLockApi.requestLockPermission();
      }
      return;
    }

    try {
      try {
        await screenLockApi.lockScreen();
      } on PlatformException catch (e) {
        setErr("Lock failed: ${e.code} - ${e.message}");
      }
    } catch (e, st) {
      setErr("please grant the permission");
      AppLogger.log("ScreenLockProviderMixin.lockScreen", e, st);
    }
  }

  Future<void> requestLockPermission() async {
    try {
      await screenLockApi.openAccessibilitySettings();
    } catch (e, st) {
      setErr("failed to request lock permission");
      AppLogger.log("ScreenLockProviderMixin.requestLockPermission", e, st);
    }
  }
}
