import 'package:brainhub/features/menu/menu_viewmodel.dart';
import 'package:brainhub/repositories/projects_repository.dart';
import 'package:provider/provider.dart';

final providers = [
  Provider<ProjectsRepository>(
    create: (context) => ProjectsRepository(),
  ),
  ChangeNotifierProvider<MenuViewModel>(
    create: (context) => MenuViewModel(
      projectsRepository: context.read<ProjectsRepository>(),
    ),
  ),
];
