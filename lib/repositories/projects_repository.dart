import 'dart:collection';

import 'package:brainhub/models/project.dart';
import 'package:brainhub/utils/result.dart';

class ProjectsRepository {
  final List<Project> _projects = [];

  UnmodifiableListView<Project> get projects => UnmodifiableListView(_projects);

  Project? getProjectByName(String name) {
    try {
      return _projects.firstWhere((project) => project.name == name);
    } catch (e) {
      return null;
    }
  }

  Future<List<Project>> loadProjects() async {
    await Future.delayed(const Duration(seconds: 1));
    return projects;
  }

  Future<Result<(), String>> addProject(String projectName) async {
    await Future.delayed(const Duration(seconds: 1));
    if(getProjectByName(projectName) != null) {
      return Result.err('Project with the same name already exists');
    }
    _projects.add(Project(name: projectName, code: ""));
    return Result.ok(());
  }

  Future<void> removeProject(Project project) async {
    await Future.delayed(const Duration(seconds: 1));
    _projects.remove(project);
  }

  Future<Result<(), String>> updateProject(Project oldProject, Project newProject) async {
    await Future.delayed(const Duration(seconds: 1));

    final oldName = oldProject.name;
    final newName = newProject.name;
    final index = _projects.indexOf(oldProject);
    if(index == -1) {
      return Result.err('"${oldName}" does not exists');
    } else if(oldName != newName && _projects.any((project) => project.name == newName)) {
      return Result.err('"${newName}" already exists');
    }

    _projects[index] = newProject;

    return Result.ok(());
  }
}
