import 'package:flutter/material.dart';

import '../core.dart';

/// THE main thing I am  thinking; I just have to 3/4 styls, a simple extension  for theme is good enough
/// The best thing you can do us just use Provider.select,
/// But I am gonna leave it like this anyway
mixin ThemeNotifier on AppNotifier {
  late final ValueNotifier<ThemeData> _themeData = ValueNotifier(_default);
  ValueNotifier<ThemeData> get themeNotifier => _themeData;
  ThemeData get theme => _themeData.value;

  void updateTheme(Brightness brightness, Color seed) {
    //FIX #6 : someday  gonna create N  themes
    if (brightness == .dark &&
        themes.first.isDark &&
        seed.toARGB32() == themes.first.seed) {
      _themeData.value = _default;
      return;
    }

    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );

    _themeData.value = _generate(scheme);
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
    // huahaha;  idc about theme now ; so if first color match use [_default]
    (name: 'Default', seed: 0xFF101010, isDark: true),
    (name: 'Minimal', seed: 0xFFE0E0E0, isDark: true),
    (name: 'Ocean', seed: 0xFF80CBC4, isDark: true),
    (name: 'Blue', seed: 0xFF90CAF9, isDark: true),
    (name: 'Violet', seed: 0xFFB39DDB, isDark: true),
    (name: 'Warm', seed: 0xFFFFCC80, isDark: true),
  ];

  /// The theme I actually use
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
