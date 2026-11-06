import 'package:hive_flutter/hive_flutter.dart';

import 'hive_adapters.dart';
import 'models/app_info.dart';
import 'models/app_visibility.dart';
import 'models/user_preference.dart';

class AppDatabase {
  static const String _configBoxName = "app_config_x3";
  static const String _visibilityBoxName = "app_visiblity_x3";
  static const String _userPrefBoxName = "user_preference_x3";

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(AppInfoAdapter());
    Hive.registerAdapter(AppVisibilityAdapter());
    Hive.registerAdapter(AppVisiblityModeAdapter());
    Hive.registerAdapter(UserPreferenceAdapter());
    await Hive.openBox<AppInfo>(_configBoxName);
    await Hive.openBox<AppVisiblityInfo>(_visibilityBoxName);
    await Hive.openBox<UserPreference>(_userPrefBoxName);
  }

  final _box = Hive.box<AppInfo>(_configBoxName);
  List<AppInfo> getAppConfigs() => _box.values.toList();

  void refreshApps(List<AppInfo> data) {
    _box.putAll({for (final e in data) e.packageName: e});
  }

  void updateConif(AppInfo info) {
    _box.put(info.packageName, info);
  }

  final _visibilityBox = Hive.box<AppVisiblityInfo>(_visibilityBoxName);
  List<AppVisiblityInfo> getVisiblityCongis() => _visibilityBox.values.toList();

  void updateVisiblity(AppVisiblityInfo value) =>
      _visibilityBox.put(value.packageName, value);

  /// ...

  final _userPreferenceBox = Hive.box<UserPreference>(_userPrefBoxName);
  void updatePreference(UserPreference pref) => _userPreferenceBox.put(0, pref);

  UserPreference preference([UserPreference defaulta = .empty]) {
    if (_userPreferenceBox.values.isEmpty) {
      _userPreferenceBox.put(0, defaulta); // dang naming
    }

    return _userPreferenceBox.values.first;
  }
}
