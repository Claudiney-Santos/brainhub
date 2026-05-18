import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class SettingsRepository extends ChangeNotifier {
  static const _boxName = 'settings';
  static const _keyThemeMode = 'themeMode';
  static const _keyFontSize = 'fontSize';
  static const _keyTapeSize = 'tapeSize';
  static const _keyStepLimit = 'stepLimit';

  late final Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  ThemeMode get themeMode {
    final index = _box.get(_keyThemeMode, defaultValue: ThemeMode.system.index);
    return ThemeMode.values[index];
  }

  double get fontSize => _box.get(_keyFontSize, defaultValue: 18.0);
  int get tapeSize => _box.get(_keyTapeSize, defaultValue: 30000);
  int get stepLimit => _box.get(_keyStepLimit, defaultValue: 100000);

  Future<void> updateThemeMode(ThemeMode newMode) async {
    if (themeMode == newMode) return;
    await _box.put(_keyThemeMode, newMode.index);
    notifyListeners();
  }

  Future<void> updateFontSize(double newSize) async {
    if (fontSize == newSize) return;
    await _box.put(_keyFontSize, newSize);
  }

  Future<void> updateTapeSize(int newSize) async {
    if (tapeSize == newSize) return;
    await _box.put(_keyTapeSize, newSize);
    notifyListeners();
  }

  Future<void> updateStepLimit(int newLimit) async {
    if (stepLimit == newLimit) return;
    await _box.put(_keyStepLimit, newLimit);
    notifyListeners();
  }
}

