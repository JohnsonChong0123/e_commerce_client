import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static final theme = ThemeData(
    textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColor.primary,
          fontSize: 25,
        ),
        titleMedium: TextStyle(
          fontSize: 20,
        ),
        bodySmall: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        )
      ),
    inputDecorationTheme: InputDecorationTheme(
      errorStyle: const TextStyle(
        fontSize: 12,
        color: Colors.red,
        fontWeight: FontWeight.normal,
      ),
      filled: true,
      fillColor: AppColor.placeholderBg,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      hintStyle: const TextStyle(
        color: AppColor.placeholder,
        fontWeight: FontWeight.normal,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.green,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const StadiumBorder(),
      ),
    ),
  );
}