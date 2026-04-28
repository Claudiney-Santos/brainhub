import 'package:brainhub/features/brainfuck_interpreter/brainfuck_interpreter.dart';
import 'package:brainhub/features/editor/editor_viewmodel.dart';
import 'package:brainhub/features/login/login_screen.dart';
import 'package:brainhub/features/login/login_viewmodel.dart';
import 'package:brainhub/features/register/register_screen.dart';
import 'package:brainhub/features/register/register_viewmodel.dart';
import 'package:brainhub/features/menu/menu_screen.dart';
import 'package:brainhub/features/editor/editor_screen.dart';
import 'package:brainhub/features/settings/settings_screen.dart';
import 'package:brainhub/repositories/projects_repository.dart';
import 'package:brainhub/repositories/settings_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String menu = '/menu';
  static const String editor = '/editor';
  static const String settings = '/settings';

  static final GoRouter routes = GoRouter(
    initialLocation: AppRouter.login,
    routes: [
      GoRoute(
        path: AppRouter.login,
        builder: (context, state) => LoginScreen(viewModel: LoginViewModel()),
      ),
      GoRoute(
        path: AppRouter.register,
        builder: (context, state) => RegisterScreen(
          viewModel: RegisterViewModel(),
        ),
      ),
      GoRoute(
        path: AppRouter.menu,
        builder: (context, state) => MenuScreen(menuViewModel: context.read()),
      ),
      GoRoute(
        path: AppRouter.editor,
        builder: (context, state) {
          final projectId = state.uri.queryParameters['id'];
          final projectsRepository = context.read<ProjectsRepository>();
          final settings = context.read<SettingsRepository>();
          return EditorScreen(
            editorViewModel: EditorViewModel(
              projectsRepository: projectsRepository,
              projectId: projectId,
              brainfuckInterpreter: BrainfuckInterpreter(
                tapeSize: settings.tapeSize,
                stepLimit: settings.stepLimit,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRouter.settings,
        builder: (context, state) =>
            SettingsScreen(settingsViewModel: context.read()),
      ),
    ],
  );
}
