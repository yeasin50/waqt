import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../core.dart';
import '../services/apps_api.g.dart' hide AppInfo;
import '../services/logger.dart';
import '../services/screen_lock_api.g.dart';
import '../services/statusbar_api.g.dart';

/// the base notifier that will connect other mixin
abstract class AppNotifier extends ChangeNotifier {
  AppNotifier(
    this._db,
    this.service, {
    required this.statusBar,
    required this.screenLockApi,
    required this.appManagerApi,
  });

  final AppDatabase _db;
  AppDatabase get db => _db;

  final AppService service;
  final ScreenLockApi screenLockApi;
  final AppManagerApi appManagerApi;
  final StatusbarFlutterApi statusBar;

  final Set<AppInfo> _apps = {};

  void removeApp(AppInfo app, [bool notify = false]) {
    _apps.remove(app);
    if (notify) notifyListeners();
  }

  void addApp(AppInfo app, [bool notify = false]) {
    _apps.add(app);
    if (notify) notifyListeners();
  }

  UnmodifiableListView<AppInfo> get apps {
    final sortItems = _apps.toList()..sort((a, b) => a.name.compareTo(b.name));
    return UnmodifiableListView(sortItems);
  }

  UnmodifiableListView<AppInfo> get favoriteApps {
    final sortedItems = _apps.where((e) => e.isFavtorite).toList()
      ..sort((a, b) => a.favoriteIndex!.compareTo(b.favoriteIndex!));

    return UnmodifiableListView(sortedItems);
  }

  /// TODO: specific error Type and create handler
  String _err = "test error view";
  String get err => _err;
  void setErr(String msg) {
    _err = msg;
    notifyListeners();
  }

  Future<void> getApps() async {
    try {
      _err = "";
      //TODO: replace with pegion
      final result = await service.getInstalledApps();

      final configedApps = _db.getAppConfigs();

      final merged = <String, AppInfo>{};
      for (final app in result) {
        final configed = configedApps.firstWhereOrNull(
          (e) => e.packageName == app.packageName,
        );
        merged[app.packageName] = configed ?? app;
      }

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
    } catch (e, st) {
      _apps.clear();
      _err = "faled to get apps";
      AppLogger.log("app_notifier.get_apps", _err, st);

      notifyListeners();
    }
  }

  Future<void> launchApp(AppInfo app) async {
    final hasLaunched = await appManagerApi.openApp(app.packageName);

    if (!hasLaunched) {
      setErr("failed to launch ${app.name}");
      AppLogger.log("app_notifier.launchApp", _err, null);
    }
  }

  Future<void> openAppInfo(AppInfo app) async {
    await appManagerApi.openAppInfo(app.packageName);
  }

  Future<void> unistallApp(AppInfo app) async {
    await appManagerApi.uninstallApp(app.packageName);
    // refresh  filtered apps
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
}
