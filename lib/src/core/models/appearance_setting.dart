part of 'user_preference.dart';

class AppearanceSetting {
  const AppearanceSetting({
    this.showStatusBar = true,
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
    this.isDarkMode = true,
    this.seedColor = 0xFF121212,
  });

  final bool showStatusBar;
  final String language;

  final bool isDarkMode;
  final int seedColor;

  @Deprecated("Use [seedColor] and thememode instead")
  final String theme;
  final bool useSystemFont;
  final String customFont;
  final int itemSpacing;
  final int fontSize;

  final bool showClock;
  // -1 = left, 0 = center, 1 = right
  final int clockAlignment;
  final bool isLargeClock;
  final bool showDate;

  // App list

  /// App name alignment.
  /// -1 = left, 0 = center, 1 = right
  final int appsNameAlignment;

  AppearanceSetting copyWith({
    bool? showStatusBar,

    bool? isDarkMode,
    int? seedColor,
    String? language,
    bool? useSystemFont,
    String? customFont,
    int? itemSpacing,
    int? fontSize,
    bool? showClock,
    int? clockAlignment,
    bool? isLargeClock,
    bool? showDate,
    int? appsNameAlignment,
  }) {
    return AppearanceSetting(
      showStatusBar: showStatusBar ?? this.showStatusBar,
      language: language ?? this.language,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      seedColor: seedColor ?? this.seedColor,
      useSystemFont: useSystemFont ?? this.useSystemFont,
      customFont: customFont ?? this.customFont,
      itemSpacing: itemSpacing ?? this.itemSpacing,
      fontSize: fontSize ?? this.fontSize,
      showClock: showClock ?? this.showClock,
      clockAlignment: clockAlignment ?? this.clockAlignment,
      isLargeClock: isLargeClock ?? this.isLargeClock,
      showDate: showDate ?? this.showDate,
      appsNameAlignment: appsNameAlignment ?? this.appsNameAlignment,
    );
  }

  Map<String, dynamic> toJson() => {
    "showStatusBar": showStatusBar,
    'language': language,
    'isDarkMode': isDarkMode,
    'seedColor': seedColor,
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
  };

  @override
  String toString() => 'Appearance(${toJson()})';
}
