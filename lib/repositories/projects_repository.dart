import 'dart:collection';

import 'package:brainhub/models/project.dart';
import 'package:brainhub/utils/id_generator.dart';
import 'package:brainhub/utils/result.dart';

class ProjectsRepository {
  final HashMap<String, Project> _projects = HashMap();

  UnmodifiableMapView<String, Project> get projects => UnmodifiableMapView(_projects);

  Project? getProjectById(String id) {
    return _projects[id];
  }

  Project? getProjectByName(String name) {
    try {
      return _projects.values.firstWhere((project) => project.name == name);
    } catch (e) {
      return null;
    }
  }

  Future<UnmodifiableMapView<String, Project>> loadProjects() async {
    await Future.delayed(const Duration(seconds: 1));
    return projects;
  }

  Future<Result<(), String>> addProject(String projectName) async {
    await Future.delayed(const Duration(seconds: 1));
    if(getProjectByName(projectName) != null) {
      return Result.err('Project with the same name already exists');
    }
    final id = IdGenerator.generateId();
    _projects[id] = Project(name: projectName, code: "");
    return Result.ok(());
  }

  Future<void> removeProject(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    _projects.remove(id);
  }

  Future<Result<(), String>> updateProject(String id, Project newProject) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      final oldProject = _projects[id]!;

      final oldName = oldProject.name;
      final newName = newProject.name;
      if(oldName != newName && _projects.values.any((project) => project.name == newName)) {
        return Result.err('"$newName" already exists');
      }

      _projects[id] = newProject;

      return Result.ok(());
    } catch (e) {
      return Result.err(e.toString());
    }
  }
}
