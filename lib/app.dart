import 'package:brainhub/theme.dart';
import 'package:flutter/material.dart';
import 'package:brainhub/router/app_router.dart';

class BrainHubApp extends StatelessWidget {
  const BrainHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BrainHub',
      debugShowCheckedModeBanner: false,
      theme: BrainHubTheme.darkTheme,
      routerConfig: AppRouter.routes,
    );
  }
}
