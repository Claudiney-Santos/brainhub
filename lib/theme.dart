import 'package:flutter/material.dart';

class BrainHubTheme {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0x003135A6),
      brightness: Brightness.light,
    ),
    useMaterial3: true,
  );

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFCECA59),
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
}
