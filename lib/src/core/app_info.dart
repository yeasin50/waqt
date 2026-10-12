class AppInfo {
  const AppInfo(this.name, this.packageName, {this.isFavtorite = false});

  final String name;
  final String packageName;
  final bool isFavtorite;

  AppInfo copyWith({bool? isFavtorite}) {
    return AppInfo(
      name,
      packageName,
      isFavtorite: isFavtorite ?? this.isFavtorite,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppInfo &&
          name == other.name &&
          packageName == other.packageName &&
          isFavtorite == other.isFavtorite;

  @override
  int get hashCode => Object.hash(name, packageName, isFavtorite);

  @override
  String toString() => "name $name pkg: $packageName isFavtorite:$isFavtorite";
}
