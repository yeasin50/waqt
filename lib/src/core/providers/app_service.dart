import 'dart:developer';

import 'package:flutter/services.dart';

import '../core.dart';
import '../exceptions.dart';

@Deprecated("replaced with pigeon")
const _channel = MethodChannel('waqt/apps');

@Deprecated("NO longer used, use [ScreenLockApi] instead")
class AppService with PhoneLockMixin {
  Future<List<AppInfo>> getInstalledApps() async {
    try {
      final result = await _channel.invokeListMethod<Map>('getApps');

      final apps = (result ?? [])
          .map(
            (app) =>
                AppInfo(app['name'].toString(), app['packageName'].toString()),
          )
          .toList();

      if (apps.isEmpty) {
        log("getInstalledApps is empty");
        throw NoAppFound();
      } else {
        return apps;
      }
    } catch (e) {
      log("getInstalledApps ${e.toString()}");
      throw NoAppInstalled();
    }
  }

  Future<void> launchApp(AppInfo app) async {
    try {
      await _channel.invokeMethod('launchApp', {
        'packageName': app.packageName,
      });
    } catch (e) {
      log("failed to launch app ${e.toString()}");
      throw FailedToLaunch();
    }
  }

  Future<void> openAppInfo(AppInfo app) async {
    try {
      await _channel.invokeMethod('openAppInfo', app.packageName);
    } catch (e) {
      log("failed to open app info ${e.toString()}");
      throw FailedToOpen();
    }
  }

  // FIXME: removed isn't working
  Future<void> unistallApp(AppInfo app) async {
    try {
      await _channel.invokeMethod('uninstallApp', app.packageName);
      print("app ${app.name} removed");
    } catch (e) {
      print("failed to unistallApp ${e.toString()}");
      throw FailedToUninstall();
    }
  }
}

@Deprecated("use pigeon's [AppManagerApi]")
mixin PhoneLockMixin {
  @deprecated
  Future<bool> hasLockPermission() async {
    try {
      return await _channel.invokeMethod<bool>('checkLockPermission') ?? false;
    } catch (e) {
      log("failed to check lock permission: ${e.toString()}");
      return false;
    }
  }

  Future<void> lockScreen() async {
    try {
      await _channel.invokeMethod('lockScreen');
    } catch (e) {
      log("failed to lock screen ${e.toString()}");
      throw LockPermissionFailed();
    }
  }

  Future<void> requestLockPermission() async {
    try {
      await _channel.invokeMethod('requestLockPermission');
    } catch (e) {
      log("failed to request lock permission ${e.toString()}");
      throw LockPermissionFailed();
    }
  }
}
