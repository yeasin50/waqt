import 'package:flutter/foundation.dart';

import 'app_visiblity.dart';

class AppInfo {
  const AppInfo(
    this.name,
    this.packageName, {
    this.favoriteIndex,
    this.visiblityInfo,
  });

  final String name;
  final String packageName;

  /// if null then  it is not added to favtorite/homePage
  final int? favoriteIndex;
  bool get isFavtorite => favoriteIndex != null;

  final AppVisiblityInfo? visiblityInfo;

  AppInfo copyWith({
    ValueGetter<int?>? favoriteIndex,
    AppVisiblityInfo? visiblityInfo,
  }) {
    return AppInfo(
      name,
      packageName,
      favoriteIndex: favoriteIndex != null
          ? favoriteIndex()
          : this.favoriteIndex,
      visiblityInfo: visiblityInfo ?? this.visiblityInfo,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppInfo &&
          name == other.name &&
          packageName == other.packageName &&
          favoriteIndex == other.favoriteIndex &&
          visiblityInfo == other.visiblityInfo;

  @override
  int get hashCode =>
      Object.hash(name, packageName, favoriteIndex, visiblityInfo);

  @override
  String toString() =>
      "name $name pkg: $packageName favoriteIndex:$favoriteIndex visiblityInfo ${visiblityInfo.toString()}";
}
