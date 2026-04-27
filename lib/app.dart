import 'package:brainhub/providers.dart';
import 'package:brainhub/theme.dart';
import 'package:flutter/material.dart';
import 'package:brainhub/router/app_router.dart';
import 'package:provider/provider.dart';

class BrainHubApp extends StatelessWidget {
  const BrainHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Consumer<ThemeMode>(
        builder: (context, theme, child) => MaterialApp.router(
          title: 'BrainHub',
          debugShowCheckedModeBanner: false,
          theme: (theme == ThemeMode.light)
            ? BrainHubTheme.lightTheme
            : BrainHubTheme.darkTheme,
          routerConfig: AppRouter.routes,
        ),
      ),
    );
  }
}
