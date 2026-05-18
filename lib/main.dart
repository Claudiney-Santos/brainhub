import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:brainhub/app.dart';
import 'package:brainhub/models/project.dart';
import 'package:brainhub/repositories/projects_repository.dart';
import 'package:brainhub/repositories/settings_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter('brainhub_data');
  Hive.registerAdapter(ProjectAdapter());

  final projectsRepo = ProjectsRepository();
  final settingsRepo = SettingsRepository();

  await projectsRepo.init();
  await settingsRepo.init();

  runApp(
    BrainHubApp(
      projectsRepository: projectsRepo,
      settingsRepository: settingsRepo,
    ),
  );
}

