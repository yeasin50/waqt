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
  });

  final bool showStatusBar;
  final String language;

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
    String? theme,
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
    );
  }

  Map<String, dynamic> toJson() => {
    "showStatusBar": showStatusBar,
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
  };

  @override
  String toString() => 'Appearance(${toJson()})';
}
