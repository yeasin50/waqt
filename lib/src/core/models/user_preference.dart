part 'search_preference.dart';

class UserPreference {
  const UserPreference({
    this.enableDoubleTapLock = false,
    this.search = const SearchConfigs(),
    // Appearance
    this.language = 'system',
    this.theme = 'system',
    this.useSystemFont = true,
    this.customFont = '',
    this.itemSpacing = 8,
    this.fontSize = 16,

    // Clock
    this.showClock = true,
    this.clockAlignment = 0,
    this.isLargeClock = false,
    this.showDate = true,

    this.appsNameAlignment = 0,
    this.footerLeft = '',
    this.footerRight = '',
  });

  final bool enableDoubleTapLock;

  final SearchConfigs search;

  // Appearance
  final String language;
  final String theme;
  final bool useSystemFont;
  final String customFont;
  final int itemSpacing;
  final int fontSize;

  // Clock
  final bool showClock;

  /// -1 = left, 0 = center, 1 = right
  final int clockAlignment;
  final bool isLargeClock;
  final bool showDate;

  // App list

  /// App name alignment.
  /// -1 = left, 0 = center, 1 = right
  final int appsNameAlignment;

  // Footer labels
  final String footerLeft;
  final String footerRight;

  static const UserPreference empty = UserPreference();

  UserPreference copyWith({
    bool? enableDoubleTapLock,
    SearchConfigs? search,
    String? language,
    String? theme,
    bool? useSystemFont,
    String? customFont,
    int? itemSpacing,
    int? fontSize,
    bool? showClock,
    int? clockAlignment,
    bool? isLargeClock,
    bool? showDate,
    int? appsNameAlignment,
    String? footerLeft,
    String? footerRight,
  }) {
    return UserPreference(
      enableDoubleTapLock: enableDoubleTapLock ?? this.enableDoubleTapLock,
      search: search ?? this.search,
      language: language ?? this.language,
      theme: theme ?? this.theme,
      useSystemFont: useSystemFont ?? this.useSystemFont,
      customFont: customFont ?? this.customFont,
      itemSpacing: itemSpacing ?? this.itemSpacing,
      fontSize: fontSize ?? this.fontSize,
      showClock: showClock ?? this.showClock,
      clockAlignment: clockAlignment ?? this.clockAlignment,
      isLargeClock: isLargeClock ?? this.isLargeClock,
      showDate: showDate ?? this.showDate,
      appsNameAlignment: appsNameAlignment ?? this.appsNameAlignment,
      footerLeft: footerLeft ?? this.footerLeft,
      footerRight: footerRight ?? this.footerRight,
    );
  }

  Map<String, dynamic> toJson() => {
    "search": search.toString(),
    'language': language,
    'theme': theme,
    'useSystemFont': useSystemFont,
    'customFont': customFont,
    'itemSpacing': itemSpacing,
    'fontSize': fontSize,
    'showClock': showClock,
    'clockAlignment': clockAlignment,
    'isLargeClock': isLargeClock,
    'showDate': showDate,
    'appsNameAlignment': appsNameAlignment,
    'footerLeft': footerLeft,
    'footerRight': footerRight,
  };

  @override
  String toString() => 'UserPreference(${toJson()})';
}
