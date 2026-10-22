import 'dart:developer';

import 'package:flutter/services.dart';

import 'app_notifier.dart';

mixin ScreenLockProviderMixin on AppNotifier {
  bool _hasLockPermission = false;
  bool get hasLockPermission => _hasLockPermission;

  Future<void> checkLockPermission() async {
    _hasLockPermission = await screenLockApi.checkLockPermission();
    notifyListeners();
  }

  Future<void> _lockScreen() async {
    assert(hasLockPermission);
    try {
      await screenLockApi.lockScreen();
    } on PlatformException catch (e) {
      setErr("Lock failed: ${e.code} - ${e.message}");
    }
  }

  Future<void> lockScreen() async {
    try {
      await _lockScreen();
    } catch (e) {
      setErr("please grant the permission");
    }
  }

  Future<void> requestLockPermission() async {
    try {
      await screenLockApi.openAccessibilitySettings();
      log("eof openAccessibilitySettings");
      // FIXME:  when  I comeback  from  openAccessibilitySettings page,  I do need to recheck  it again
      await checkLockPermission(); // this is not working
    } catch (e) {
      print("requestLockPermission ${e.toString()}");
      setErr("failed to request lock permission");
    }
  }
}
