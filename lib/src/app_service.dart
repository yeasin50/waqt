import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _channel = MethodChannel('waqt/apps');

class AppService extends ChangeNotifier {
  ///
  final List<AppInfo> _apps = [];

  UnmodifiableListView<AppInfo> get apps => UnmodifiableListView(_apps);

  String _err = "";
  Future<void> getInstalledApps() async {
    try {
      final result = await _channel.invokeListMethod<Map>('getApps');

      final apps = (result ?? [])
          .map(
            (app) =>
                AppInfo(app['name'].toString(), app['packageName'].toString()),
          )
          .toList();

      if (apps.isEmpty) {
        _err == "no app found";
        log("getInstalledApps is empty");
      } else {
        _apps.clear();
        _apps.addAll(apps);
      }
    } catch (e) {
      _apps.clear();

      _err = "faled to get apps";
      log("getInstalledApps ${e.toString()}");
    } finally {
      notifyListeners();
    }
  }

  Future<void> launchApp(AppInfo app) async {
    try {
      await _channel.invokeMethod('launchApp', {
        'packageName': app.packageName,
      });
    } catch (e) {
      log("failed to launch app ${e.toString()}");
      _err = "failed to launch ${app.name}";
      notifyListeners();
    }
  }

  Future<void> openAppInfo(AppInfo app) async {
    try {
      await _channel.invokeMethod('openAppInfo', app.packageName);
    } catch (e) {
      log("failed to open app info ${e.toString()}");
      _err = "failed to open app info ${app.name}";
      notifyListeners();
    }
  }

  // FIXME: removed isn't working
  Future<void> unistallApp(AppInfo app) async {
    try {
      await _channel.invokeMethod('uninstallApp', app.packageName);
      print("app ${app.name} removed");
    } catch (e) {
      print("failed to unistallApp ${e.toString()}");
      _err = "failed to unistall app ${app.name}";
      notifyListeners();
    }
  }

  Future<void> lockScreen() async {
    try {
      await _channel.invokeMethod('lockScreen');
    } catch (e) {
      log("failed to lock screen ${e.toString()}");
      _err = "please grant the permission";
      notifyListeners();
    }
  }

  Future<void> requestLockPermission() async {
    try {
      await _channel.invokeMethod('requestLockPermission');
    } catch (e) {
      log("failed to request lock permission ${e.toString()}");
      _err = "failed to request lock permission";
      notifyListeners();
    }
  }
}

class AppInfo {
  const AppInfo(this.name, this.packageName);
  final String name;
  final String packageName;

  @override
  String toString() => "name $name pkg: $packageName";
}

class AppProvider extends InheritedWidget {
  const AppProvider({super.key, required super.child, required this.service});

  final AppService service;

  static AppProvider of(BuildContext context) {
    final AppProvider? result = maybeOf(context);
    assert(result != null, 'No AppProvider found in context');
    return result!;
  }

  static AppProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppProvider>();
  }

  @override
  bool updateShouldNotify(AppProvider oldWidget) =>
      service != oldWidget.service;
}
