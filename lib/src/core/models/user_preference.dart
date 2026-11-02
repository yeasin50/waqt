part 'search_preference.dart';
part 'appearance_setting.dart';

class UserPreference {
  const UserPreference({
    this.enableDoubleTapLock = false,
    this.search = const SearchConfigs(),
    this.appearance = const AppearanceSetting(),

    this.footerLeft = '',
    this.footerRight = '',
  });

  final bool enableDoubleTapLock;

  final SearchConfigs search;
  final AppearanceSetting appearance;

  // Footer labels
  final String footerLeft;
  final String footerRight;

  static const UserPreference empty = UserPreference();

  UserPreference copyWith({
    bool? enableDoubleTapLock,
    SearchConfigs? search,
    AppearanceSetting? appearance,
    String? footerLeft,
    String? footerRight,
  }) {
    return UserPreference(
      enableDoubleTapLock: enableDoubleTapLock ?? this.enableDoubleTapLock,
      search: search ?? this.search,
      appearance: appearance ?? this.appearance,
      footerLeft: footerLeft ?? this.footerLeft,
      footerRight: footerRight ?? this.footerRight,
    );
  }

  Map<String, dynamic> toJson() => {
    "search": search.toString(),
    'appearance': appearance.toString(),
    'footerLeft': footerLeft,
    'footerRight': footerRight,
  };

  @override
  String toString() => 'UserPreference(${toJson()})';
}
