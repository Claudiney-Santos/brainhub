import 'package:flutter/material.dart';
import 'package:brainhub/router/app_router.dart';

class BrainHubApp extends StatelessWidget {
  const BrainHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BrainHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFCECA59),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.routes,
    );
  }
}
