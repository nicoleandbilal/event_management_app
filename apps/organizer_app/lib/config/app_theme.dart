// lib/config/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    appBarTheme: const AppBarTheme(
      color: Colors.blueAccent,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.blueAccent,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),  // Updated
      bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400), // Updated
    ),
  );
}
