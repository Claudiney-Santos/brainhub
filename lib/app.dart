import 'package:brainhub/providers.dart';
import 'package:brainhub/repositories/settings_repository.dart';
import 'package:brainhub/router/app_router.dart';
import 'package:brainhub/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrainHubApp extends StatelessWidget {
  final SettingsRepository settingsRepository;

  const BrainHubApp({super.key, required this.settingsRepository});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: buildProviders(settingsRepository: settingsRepository).cast(),
      child: Consumer<SettingsRepository>(
        builder: (context, settings, child) {
          return MaterialApp.router(
            title: 'BrainHub',
            debugShowCheckedModeBanner: false,
            theme: (settings.themeMode == ThemeMode.light)
                ? BrainHubTheme.lightTheme
                : BrainHubTheme.darkTheme,
            routerConfig: AppRouter.routes,
          );
        },
      ),
    );
  }
}

