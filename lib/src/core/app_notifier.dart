import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'core.dart';

class AppNotifier extends AppService with ChangeNotifier {
  AppNotifier(this._db);

  final AppDatabase _db;
  final Set<AppInfo> _apps = {};

  AppPreference get preference => _db.preference;

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

  Future<void> getApps() async {
    try {
      _err = "";
      final result = await super.getInstalledApps();

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

  /// Not certain whether I should just use the super class instead and handle exception  into ui,
  /// But that will look bad
  @override
  Future<void> launchApp(AppInfo app) async {
    try {
      await super.launchApp(app);
    } catch (e) {
      log("failed to launch app ${e.toString()}");
      _err = "failed to launch ${app.name}";
      notifyListeners();
    }
  }

  @override
  Future<void> openAppInfo(AppInfo app) async {
    try {
      await super.openAppInfo(app);
    } catch (e) {
      _err = "failed to open app info ${app.name}";
      notifyListeners();
    }
  }

  // FIXME: removed isn't working
  @override
  Future<void> unistallApp(AppInfo app) async {
    try {
      await super.unistallApp(app);
      print("app ${app.name} removed");
    } catch (e) {
      _err = "failed to unistall app ${app.name}";
      notifyListeners();
    }
  }

  @override
  Future<void> lockScreen() async {
    try {
      await super.lockScreen();
    } catch (e) {
      _err = "please grant the permission";
      notifyListeners();
    }
  }

  @override
  Future<void> requestLockPermission() async {
    try {
      await super.requestLockPermission();
    } catch (e) {
      _err = "failed to request lock permission";
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
}
