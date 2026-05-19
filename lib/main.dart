import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:brainhub/app.dart';
import 'package:brainhub/repositories/settings_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter('brainhub_data');

  final settingsRepo = SettingsRepository();
  await settingsRepo.init();

  await Supabase.initialize(
    url: 'https://desjhxyjssfmfeeepinw.supabase.co',
    anonKey: 'sb_publishable_t2OoZ7UZfHemPnOZVzeiAg_Kc3n_FdJ',
  );

  runApp(BrainHubApp(settingsRepository: settingsRepo));
}

