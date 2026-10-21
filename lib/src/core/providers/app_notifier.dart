import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core.dart';
import '../models/user_preference.dart';
import '../services/screen_lock_api.g.dart';

class AppNotifier extends ChangeNotifier {
  AppNotifier(this._db, this.service, this.screenLockApi) {
    checkLockPermission();
  }

  final AppDatabase _db;
  final AppService service;
  final ScreenLockApi screenLockApi;
  AppDatabase get db => _db;

  final Set<AppInfo> _apps = {};

  late UserPreference _preference = _db.preference();
  UserPreference get preference => _preference;

  UnmodifiableListView<AppInfo> get apps {
    final sortItems = _apps.toList()..sort((a, b) => a.name.compareTo(b.name));
    return UnmodifiableListView(sortItems);
  }

  UnmodifiableListView<AppInfo> get favoriteApps {
    final sortedItems = _apps.where((e) => e.isFavtorite).toList()
      ..sort((a, b) => a.favoriteIndex!.compareTo(b.favoriteIndex!));

    return UnmodifiableListView(sortedItems);
  }

  String _err = "";
  String get err => _err;
  void setErr(String msg) {
    _err = msg;
    notifyListeners();
  }

  Future<void> getApps() async {
    try {
      _err = "";
      final result = await service.getInstalledApps();

      final merged = <String, AppInfo>{
        for (final app in result) app.packageName: app,
        for (final app in _db.getAppConfigs()) app.packageName: app,
      };

      final visibilityCongfigs = _db.getVisiblityCongis();
      for (final v in visibilityCongfigs) {
        if (!merged.keys.contains(v.packageName)) continue;

        merged[v.packageName] = merged[v.packageName]!.copyWith(
          visiblityInfo: v,
        );
      }

      _apps
        ..clear()
        ..addAll(merged.values);

      notifyListeners();
    } catch (e) {
      _apps.clear();
      _err = "faled to get apps";

      notifyListeners();
    }
  }

  Future<void> launchApp(AppInfo app) async {
    try {
      await service.launchApp(app);
    } catch (e) {
      log("failed to launch app ${e.toString()}");
      _err = "failed to launch ${app.name}";
      notifyListeners();
    }
  }

  Future<void> openAppInfo(AppInfo app) async {
    try {
      await service.openAppInfo(app);
    } catch (e) {
      _err = "failed to open app info ${app.name}";
      notifyListeners();
    }
  }

  // FIXME: removed isn't working
  Future<void> unistallApp(AppInfo app) async {
    try {
      await service.unistallApp(app);
      print("app ${app.name} removed");
    } catch (e) {
      _err = "failed to unistall app ${app.name}";
      notifyListeners();
    }
  }

  static const int _deltaGap = 1000;
  int get _newItemPositionIndex {
    return favoriteApps.isEmpty
        ? _deltaGap
        : favoriteApps.last.favoriteIndex! + _deltaGap;
  }

  void toggleFavorite(AppInfo app, [bool isFav = true]) {
    final updateItem = app.copyWith(
      favoriteIndex: () => isFav ? _newItemPositionIndex : null,
    );
    _db.updateConif(updateItem);
    _apps.remove(app);
    _apps.add(updateItem);
    notifyListeners();
  }

  void _refreshAppPosition() {
    final favApps = favoriteApps.toList();
    _apps.removeWhere((e) => e.isFavtorite);

    for (int i = 0; i < favApps.length; i++) {
      final newPosition = () => i * _deltaGap + _deltaGap;
      favApps[i] = favApps[i].copyWith(favoriteIndex: newPosition);
    }
    _apps.addAll(favApps);
  }

  /// 🤔: SO I have been thinking is,  I can just a list of packageId which  can handle insert the way  we like.
  /// so  that I don;t have to put index field into each appInfo, but  rather just compare pkgId and returns favoriteApps
  /// How much  it make difference?
  /// I don't have to worry about position which need to reOrder on after certain position to prevent none-different position.
  /// What I loss, well nothing .... Compare & sort
  void reOrderFavotireApp(int oldIndex, int newIndex) {
    final items = favoriteApps.toList();
    final movedApp = items[oldIndex];
    items.removeAt(oldIndex);

    final int newPosition;
    if (newIndex == 0) {
      newPosition = items.first.favoriteIndex! ~/ 2;
    } else if (newIndex == items.length) {
      newPosition = items.last.favoriteIndex! + _deltaGap;
    } else {
      final prev = items[newIndex - 1].favoriteIndex!;
      final next = items[newIndex].favoriteIndex!;
      if (next - prev == 1) {
        _refreshAppPosition();
        return reOrderFavotireApp(oldIndex, newIndex);
      } else {
        newPosition = prev + (next - prev) ~/ 2;
      }
    }

    _apps.removeWhere((e) => e.packageName == movedApp.packageName);

    final updatedApp = movedApp.copyWith(favoriteIndex: () => newPosition);
    _db.updateConif(updatedApp);
    _apps.add(updatedApp);
    notifyListeners();
  }

  void updateVibilityConfig(AppVisiblityInfo info) {
    _db.updateVisiblity(info);
    final app = _apps.firstWhereOrNull(
      (e) => e.packageName == info.packageName,
    );

    if (app == null) return;

    final temp = app.copyWith(visiblityInfo: info);
    _apps.remove(app);
    _apps.add(temp);

    notifyListeners();
  }

  /// will shit elsewhere

  bool _hasLockPermission = false;
  bool get hasLockPermission => _hasLockPermission;

  Future<void> checkLockPermission() async {
    _hasLockPermission = await service.hasLockPermission();

    notifyListeners();
  }

  Future<void> _lockScreen() async {
    try {
      final isEnabled = await screenLockApi.checkLockPermission();
      if (!isEnabled) {
        // Accessibility service isn't turned on yet
        // Guide user to Android Settings -> Accessibility
        return;
      }
      await screenLockApi.lockScreen();
    } on PlatformException catch (e) {
      debugPrint("Lock failed: ${e.code} - ${e.message}");
    }
  }

  Future<void> lockScreen() async {
    try {
      await _lockScreen();
      // await service.lockScreen();
      //
    } catch (e) {
      setErr("please grant the permission");
    }
  }

  Future<void> requestLockPermission() async {
    try {
      await service.requestLockPermission();
    } catch (e) {
      setErr("failed to request lock permission");
    }
  }

  void toggleDoubleTapLoc(bool enable) {
    final updateValue = preference.copyWith(enableDoubleTapLock: enable);
    db.updatePreference(updateValue);
    _preference = updateValue;
    notifyListeners();
  }
}
