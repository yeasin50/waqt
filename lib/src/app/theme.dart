import 'package:flutter/material.dart';

final class AppTheme {
  ThemeData baseTheme(BuildContext context) => ThemeData(
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
