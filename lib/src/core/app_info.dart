import 'app_visiblity.dart';

class AppInfo {
  const AppInfo(
    this.name,
    this.packageName, {
    this.isFavtorite = false,
    this.visiblityInfo,
  });

  final String name;
  final String packageName;
  final bool isFavtorite;

  final AppVisiblityInfo? visiblityInfo;

  AppInfo copyWith({bool? isFavtorite, AppVisiblityInfo? visiblityInfo}) {
    return AppInfo(
      name,
      packageName,
      isFavtorite: isFavtorite ?? this.isFavtorite,
      visiblityInfo: visiblityInfo ?? this.visiblityInfo,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppInfo &&
          name == other.name &&
          packageName == other.packageName &&
          isFavtorite == other.isFavtorite &&
          visiblityInfo == other.visiblityInfo;

  @override
  int get hashCode =>
      Object.hash(name, packageName, isFavtorite, visiblityInfo);

  @override
  String toString() =>
      "name $name pkg: $packageName isFavtorite:$isFavtorite visiblityInfo ${visiblityInfo.toString()}";
}
