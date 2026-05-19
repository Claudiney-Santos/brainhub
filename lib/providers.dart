import 'package:brainhub/features/menu/menu_viewmodel.dart';
import 'package:brainhub/features/settings/settings_viewmodel.dart';
import 'package:brainhub/repositories/projects_repository.dart';
import 'package:brainhub/repositories/settings_repository.dart';
import 'package:provider/provider.dart';

List buildProviders({required SettingsRepository settingsRepository}) {
  return [
    Provider<ProjectsRepository>(create: (_) => ProjectsRepository()),
    ChangeNotifierProvider<SettingsRepository>.value(value: settingsRepository),
    ChangeNotifierProvider<MenuViewModel>(
      create: (context) =>
          MenuViewModel(projectsRepository: context.read<ProjectsRepository>()),
    ),
    ChangeNotifierProvider<SettingsViewModel>(
      create: (context) => SettingsViewModel(
        settingsRepository: context.read<SettingsRepository>(),
      ),
    ),
  ];
}

