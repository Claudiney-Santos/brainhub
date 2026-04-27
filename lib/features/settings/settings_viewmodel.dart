import 'package:brainhub/repositories/settings_repository.dart';
import 'package:flutter/material.dart';

class SettingsViewModel extends ChangeNotifier {
  final SettingsRepository settingsRepository;

  bool _isLoaded = false;
  ThemeMode? _themeMode;
  double? _fontSize;
  int? _tapeSize;
  int? _stepLimit;

  SettingsViewModel({required this.settingsRepository});

  bool get isLoaded => _isLoaded;
  ThemeMode? get themeMode => _themeMode;
  double? get fontSize => _fontSize;
  int? get tapeSize => _tapeSize;
  int? get stepLimit => _stepLimit;

  void loadSettings() {
    _isLoaded = false;
    notifyListeners();

    _themeMode = settingsRepository.themeMode;
    _fontSize = settingsRepository.fontSize;
    _tapeSize = settingsRepository.tapeSize;
    _stepLimit = settingsRepository.stepLimit;
    _isLoaded = true;
    notifyListeners();

    print('Loaded settings: themeMode=$_themeMode, fontSize=$_fontSize, tapeSize=$_tapeSize, stepLimit=$_stepLimit');
  }

  Future<void> updateThemeMode(ThemeMode newMode) async {
    _isLoaded = false;
    notifyListeners();
    await settingsRepository.updateThemeMode(newMode);
    _themeMode = newMode;
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> updateFontSize(double newSize) async {
    _isLoaded = false;
    notifyListeners();
    await settingsRepository.updateFontSize(newSize);
    _fontSize = newSize;
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> updateTapeSize(int newSize) async {
    _isLoaded = false;
    notifyListeners();
    await settingsRepository.updateTapeSize(newSize);
    _tapeSize = newSize;
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> updateStepLimit(int newLimit) async {
    _isLoaded = false;
    notifyListeners();
    await settingsRepository.updateStepLimit(newLimit);
    _stepLimit = newLimit;
    _isLoaded = true;
    notifyListeners();
  }
}
