// base_theme.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

class BaseTheme {
  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: LightTheme.textMedium,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: TextTheme(
      bodyLarge: LightTheme.textMedium,
      bodyMedium: LightTheme.textSmall,
      bodySmall: LightTheme.textSmall,

      titleLarge:LightTheme.largeText ,
      titleSmall: LightTheme.textSmall,
      titleMedium: LightTheme.textMedium,
    ),
  );

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Color(0xFF101127),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF101127),
      titleTextStyle: DarkTheme.textMedium,
      iconTheme: IconThemeData(color: AppColors.white),
    ),
    textTheme: TextTheme(
      bodyLarge: DarkTheme.textMedium,
      bodyMedium: DarkTheme.textSmall,
      bodySmall: DarkTheme.textSmall,

      titleLarge:DarkTheme.largeText ,
      titleSmall: DarkTheme.textSmall,
      titleMedium: DarkTheme.textMedium,
    ),

  );
}
