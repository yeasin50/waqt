import 'package:hive_flutter/hive_flutter.dart';

import 'app_info.dart';
import 'app_visiblity.dart';

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

class AppVisibilityAdapter extends TypeAdapter<AppVisiblityInfo> {
  @override
  int get typeId => 2;

  @override
  void write(BinaryWriter writer, AppVisiblityInfo obj) {
    writer.write(obj.packageName);
    writer.write(obj.mode);
    writer.write(obj.weekDays);
    writer.write(obj.monthDays);
    writer.write(obj.dailyBlocksDurationInMin);
    writer.write(obj.dailyblocks);
  }

  @override
  AppVisiblityInfo read(BinaryReader reader) {
    return AppVisiblityInfo(
      packageName: reader.read(),
      mode: reader.read(),
      weekDays: reader.read(),
      monthDays: reader.read(),
      dailyBlocksDurationInMin: reader.read(),
      dailyblocks: reader.read(),
    );
  }
}

class AppVisiblityModeAdapter extends TypeAdapter<AppVisiblityMode> {
  @override
  final int typeId = 100;

  @override
  AppVisiblityMode read(BinaryReader reader) {
    return AppVisiblityMode.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, AppVisiblityMode obj) {
    writer.writeByte(obj.index);
  }
}

class AppPreference {}

class AppDatabase {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(AppInfoAdapter());
    Hive.registerAdapter(AppVisibilityAdapter());
    Hive.registerAdapter(AppVisiblityModeAdapter());
    await Hive.openBox<AppInfo>("app_configx");
    await Hive.openBox<AppVisiblityInfo>("app_visiblityx");
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

  AppPreference get preference => AppPreference();
}
