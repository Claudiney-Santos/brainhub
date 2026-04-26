import 'package:brainhub/features/editor/editor_viewmodel.dart';
import 'package:brainhub/features/login/login_screen.dart';
import 'package:brainhub/features/login/login_viewmodel.dart';
import 'package:brainhub/features/menu/menu_screen.dart';
import 'package:brainhub/features/editor/editor_screen.dart';
import 'package:brainhub/features/menu/menu_viewmodel.dart';
import 'package:brainhub/features/settings/settings_screen.dart';
import 'package:brainhub/repositories/projects_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
        builder: (context, state) => LoginScreen(
          viewModel: LoginViewModel(),
        ),
      ),
      GoRoute(
        path: AppRouter.menu,
        builder: (context, state) => MenuScreen(
          menuViewModel: context.read(),
        ),
      ),
      GoRoute(
        path: AppRouter.editor,
        builder: (context, state) {
          final projectId = state.uri.queryParameters['id'];
          final projectsRepository = context.read<ProjectsRepository>();
          print('Navigating to editor with project ID: $projectId');
          return EditorScreen(
            editorViewModel: EditorViewModel(
              projectsRepository: projectsRepository,
              projectId: projectId,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRouter.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
