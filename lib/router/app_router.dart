import 'package:flutter/material.dart';
import 'package:brainhub/features/login/login_screen.dart';
import 'package:brainhub/features/login/login_viewmodel.dart';
import 'package:brainhub/features/menu/menu_screen.dart';
//import 'package:brainhub/screens/editor_screen.dart';
//import 'package:brainhub/screens/settings_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const String login = '/login';
  static const String menu = '/menu';
  static const String editor = '/editor';
  static const String settings = '/settings';

  static GoRouter get routes => GoRouter(
    initialLocation: AppRouter.login,
    routes: [
      GoRoute(
        path: AppRouter.login,
        builder: (context, state) => const LoginScreen(
          viewModel: LoginViewModel(),
        ),
      ),
      GoRoute(
        path: AppRouter.menu,
        builder: (context, state) => const MenuScreen(),
      ),
      // GoRoute(
      //   path: AppRouter.editor,
      //   builder: (context, state) => const EditorScreen(),
      // ),
      // GoRoute(
      //   path: AppRouter.settings,
      //   builder: (context, state) => const SettingsScreen(),
      // ),
    ],
  );
}
