import 'package:hive_flutter/hive_flutter.dart';

import 'app_info.dart';

class AppInfoAdapter extends TypeAdapter<AppInfo> {
  @override
  AppInfo read(BinaryReader reader) {
    return AppInfo(
      reader.read(),
      reader.read(),
      isFavtorite: reader.read(), //
    );
  }

  @override
  int get typeId => 1;

  @override
  void write(BinaryWriter writer, AppInfo obj) {
    writer.write(obj.name);
    writer.write(obj.packageName);
    writer.write(obj.isFavtorite);
  }
}

class AppDatabase {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(AppInfoAdapter());
    await Hive.openBox<AppInfo>("app_configx");
  }

  final _box = Hive.box<AppInfo>("app_configx");

  List<AppInfo> getAppConfigs() => _box.values.toList();

  void refreshApps(List<AppInfo> data) {
    _box.putAll({for (final e in data) e.packageName: e});
  }

  void updateConif(AppInfo info) {
    _box.put(info.packageName, info);
  }
}
