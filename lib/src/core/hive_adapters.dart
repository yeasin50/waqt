import 'package:hive_flutter/hive_flutter.dart';

import 'core.dart';
import 'models/user_preference.dart';

class AppInfoAdapter extends TypeAdapter<AppInfo> {
  @override
  AppInfo read(BinaryReader reader) {
    return AppInfo(
      reader.read(),
      reader.read(),
      favoriteIndex: reader.read(), //
    );
  }

  @override
  int get typeId => 1;

  @override
  void write(BinaryWriter writer, AppInfo obj) {
    writer.write(obj.name);
    writer.write(obj.packageName);
    writer.write(obj.favoriteIndex);
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

class UserPreferenceAdapter extends TypeAdapter<UserPreference> {
  @override
  int get typeId => 3;

  @override
  UserPreference read(BinaryReader reader) {
    return UserPreference(enableDoubleTapLock: reader.read());
  }

  @override
  void write(BinaryWriter writer, UserPreference obj) {
    writer.write(obj.enableDoubleTapLock);
  }
}
