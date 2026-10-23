import 'package:hive_flutter/hive_flutter.dart';

import 'hive_adapters.dart';
import 'models/app_info.dart';
import 'models/app_visibility.dart';
import 'models/user_preference.dart';

class AppDatabase {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(AppInfoAdapter());
    Hive.registerAdapter(AppVisibilityAdapter());
    Hive.registerAdapter(AppVisiblityModeAdapter());
    Hive.registerAdapter(UserPreferenceAdapter());
    await Hive.openBox<AppInfo>("app_configx");
    await Hive.openBox<AppVisiblityInfo>("app_visiblityx");
    await Hive.openBox<UserPreference>("user_preferencex");
  }

  final _box = Hive.box<AppInfo>("app_configx");

  List<AppInfo> getAppConfigs() => _box.values.toList();

  void refreshApps(List<AppInfo> data) {
    _box.putAll({for (final e in data) e.packageName: e});
  }

  void updateConif(AppInfo info) {
    _box.put(info.packageName, info);
  }

  final _visibilityBox = Hive.box<AppVisiblityInfo>("app_visiblityx");
  List<AppVisiblityInfo> getVisiblityCongis() => _visibilityBox.values.toList();

  void updateVisiblity(AppVisiblityInfo value) =>
      _visibilityBox.put(value.packageName, value);

  /// ...

  final _userPreferenceBox = Hive.box<UserPreference>("user_preferencex");
  void updatePreference(UserPreference pref) => _userPreferenceBox.put(0, pref);

  UserPreference preference([UserPreference defaulta = .empty]) {
    if (_userPreferenceBox.values.isEmpty) {
      _userPreferenceBox.put(0, defaulta); // dang naming
    }

    return _userPreferenceBox.values.first;
  }
}
