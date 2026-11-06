import 'package:flutter/material.dart';

import '../core.dart';
import '../models/user_preference.dart';

/// THE main thing I am  thinking; I just have to 3/4 styls, a simple extension  for theme is good enough
/// The best thing you can do us just use Provider.select,
/// But I am gonna leave it like this anyway
mixin ThemeNotifier on AppNotifier {
  late final ValueNotifier<ThemeData> _themeData = ValueNotifier(_default);
  ValueNotifier<ThemeData> get themeNotifier => _themeData;
  ThemeData get theme => _themeData.value;

  Brightness get brightness => _userPref.appearance.isDarkMode ? .dark : .light;
  Color get seedColor => Color(_userPref.appearance.seedColor);

  late UserPreference _userPref;

  void loadTheme() {
    _userPref = db.preference();
    final appearance = _userPref.appearance;

    updateTheme(
      appearance.isDarkMode ? .dark : .light,
      Color(appearance.seedColor),
    );
  }

  void updateTheme(Brightness brightness, Color seed) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );

    _themeData.value = _generate(scheme);

    _userPref = _userPref.copyWith(
      appearance: _userPref.appearance.copyWith(
        seedColor: seed.toARGB32(),
        isDarkMode: brightness == .dark,
      ),
    );

    db.updatePreference(_userPref);
  }

  ThemeData _generate(ColorScheme scheme) => ThemeData(
    colorScheme: scheme,
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 68,
        fontWeight: FontWeight.w300,
        letterSpacing: -3,
        color: scheme.onSurface,
      ),
      bodyLarge: TextStyle(
        fontWeight: FontWeight.w400,
        color: scheme.onSurface.withValues(alpha: .75),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: scheme.onSurface.withValues(alpha: .7),
      ),
      bodySmall: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
      labelMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w400,
        color: scheme.onSurface.withValues(alpha: .75),
      ),
    ),
  );

  static const List<({String name, int seed, bool isDark})> themes = [
    (name: 'Default', seed: 0xFF607D8B, isDark: true),
    (name: 'Ocean', seed: 0xFF00897B, isDark: true),
    (name: 'Violet', seed: 0xFF9575CD, isDark: true),
    (name: 'Warm', seed: 0xFFBF8050, isDark: true),
    (name: 'Minimal', seed: 0xFF78909C, isDark: false),
    (name: 'Blue', seed: 0xFF5472D3, isDark: false),
    (name: 'Rose', seed: 0xFFCC7185, isDark: false),
  ];

  /// The theme I actually use
  @deprecated
  ThemeData get _default => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF101010),
    colorScheme: const .dark(surface: Color(0xFF101010), primary: Colors.white),
    dividerColor: Colors.grey.withValues(alpha: .3),
    appBarTheme: AppBarThemeData(elevation: 0, scrolledUnderElevation: 0),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 68,
        fontWeight: FontWeight.w300,
        letterSpacing: -3,
      ),

      bodyLarge: TextStyle(
        fontWeight: .w400,
        color: Colors.white.withValues(alpha: 0.75),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.white.withValues(alpha: 0.7),
      ),
      bodySmall: TextStyle(fontSize: 12, color: Color(0xFF999999)),

      // for appTile
      labelMedium: TextStyle(
        fontSize: 22,
        fontWeight: .w400,
        color: Colors.white.withValues(alpha: 0.75),
      ),
    ),
  );
}
