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

// ONE MORE adapter changes,  gonna generate
class UserPreferenceAdapter extends TypeAdapter<UserPreference> {
  @override
  int get typeId => 4;

  //! NO, Don't follow my pattern; if you don;t understand how hive works internally
  @override
  UserPreference read(BinaryReader reader) {
    return UserPreference(
      enableDoubleTapLock: reader.readBool(),
      search: SearchConfigs(
        showSearch: reader.readBool(),
        quickSearch: reader.readBool(),
        autoShowKeyboard: reader.readBool(),
        searchOrder: reader.readString(),
        searchAtBottom: reader.readBool(),
      ),
      appearance: AppearanceSetting(
        showStatusBar: reader.readBool(),
        language: reader.readString(),
        theme: reader.readString(),
        useSystemFont: reader.readBool(),
        customFont: reader.readString(),
        itemSpacing: reader.readInt(),
        fontSize: reader.readInt(),
        showClock: reader.readBool(),
        clockAlignment: reader.readInt(),
        isLargeClock: reader.readBool(),
        showDate: reader.readBool(),
        appsNameAlignment: reader.readInt(),
      ),
      footerLeft: reader.readString(),
      footerRight: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, UserPreference obj) {
    writer
      ..writeBool(obj.enableDoubleTapLock)
      ..writeBool(obj.search.showSearch)
      ..writeBool(obj.search.quickSearch)
      ..writeBool(obj.search.autoShowKeyboard)
      ..writeString(obj.search.searchOrder)
      ..writeBool(obj.search.searchAtBottom)
      ..writeBool(obj.appearance.showStatusBar)
      ..writeString(obj.appearance.language)
      ..writeString(obj.appearance.theme)
      ..writeBool(obj.appearance.useSystemFont)
      ..writeString(obj.appearance.customFont)
      ..writeInt(obj.appearance.itemSpacing)
      ..writeInt(obj.appearance.fontSize)
      ..writeBool(obj.appearance.showClock)
      ..writeInt(obj.appearance.clockAlignment)
      ..writeBool(obj.appearance.isLargeClock)
      ..writeBool(obj.appearance.showDate)
      ..writeInt(obj.appearance.appsNameAlignment)
      ..writeString(obj.footerLeft)
      ..writeString(obj.footerRight);
  }
}
