import 'package:brainhub/features/menu/menu_viewmodel.dart';
import 'package:brainhub/features/settings/settings_viewmodel.dart';
import 'package:brainhub/repositories/settings_repository.dart';
import 'package:brainhub/repositories/projects_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final providers = [
  Provider<ProjectsRepository>(
    create: (context) => ProjectsRepository(),
  ),
  ChangeNotifierProvider<SettingsRepository>(
    create: (context) => SettingsRepository(),
  ),
  ChangeNotifierProvider<MenuViewModel>(
    create: (context) => MenuViewModel(
      projectsRepository: context.read<ProjectsRepository>(),
    ),
  ),
  ChangeNotifierProvider<SettingsViewModel>(
    create: (context) => SettingsViewModel(
      settingsRepository: context.read<SettingsRepository>(),
    ),
  ),
];
