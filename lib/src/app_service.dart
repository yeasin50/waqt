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
}

class AppInfo {
  const AppInfo(this.name, this.packageName);
  final String name;
  final String packageName;

  @override
  String toString() => "name $name pkg: $packageName";
}
