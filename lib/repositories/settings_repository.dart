import 'package:flutter/material.dart';

class SettingsRepository extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  double _fontSize = 18;
  int _tapeSize = 30000;
  int _stepLimit = 100000;

  ThemeMode get themeMode => _themeMode;
  double get fontSize => _fontSize;
  int get tapeSize => _tapeSize;
  int get stepLimit => _stepLimit;

  Future<void> updateThemeMode(ThemeMode newMode) async {
    if(_themeMode == newMode) return;
    _themeMode = newMode;
    notifyListeners();
  }

  Future<void> updateFontSize(double newSize) async {
    if(_fontSize == newSize) return;
    _fontSize = newSize;
  }

  Future<void> updateTapeSize(int newSize) async {
    if(_tapeSize == newSize) return;
    _tapeSize = newSize;
  }

  Future<void> updateStepLimit(int newLimit) async {
    if(_stepLimit == newLimit) return;
    _stepLimit = newLimit;
  }
}
