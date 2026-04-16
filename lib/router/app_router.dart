import 'package:flutter/material.dart';
import 'package:brainhub/screens/login_screen.dart';
//import 'package:brainhub/screens/menu_screen.dart';
//import 'package:brainhub/screens/editor_screen.dart';
//import 'package:brainhub/screens/settings_screen.dart';

class AppRouter {
  static const String login = '/login';
  static const String menu = '/menu';
  static const String editor = '/editor';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes => {
    login: (_) => const LoginScreen(),
    //menu: (_) => const MenuScreen(),
    //editor: (_) => const EditorScreen(),
    //settings: (_) => const SettingsScreen(),
  };
}
