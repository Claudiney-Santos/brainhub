import 'package:brainhub/models/project.dart';
import 'package:brainhub/repositories/projects_repository.dart';
import 'package:brainhub/utils/result.dart';
import 'package:flutter/material.dart';

class MenuViewModel extends ChangeNotifier {
  bool isLoaded = false;
  List<Project> projects = [];

  final ProjectsRepository _projectsRepository;

  MenuViewModel({required ProjectsRepository projectsRepository})
    : _projectsRepository = projectsRepository;

  void load() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      isLoaded = false;
      notifyListeners();
      projects = (await _projectsRepository.loadProjects()).toList();
      isLoaded = true;
      notifyListeners();
    });
  }

  Future<Result<(), String>> addProject(String projectName) async {
    isLoaded = false;
    notifyListeners();
    final result = await _projectsRepository.addProject(projectName);
    load();
    return result;
  }

  Future<Result<(), String>> renameProject(String id, String newName) async {
    try {
      final oldProject = projects.firstWhere((p) => p.id == id);
      if (oldProject.name == newName) return Result.ok(());

      final newProject = oldProject.copyWith(name: newName);
      isLoaded = false;
      notifyListeners();
      final result = await _projectsRepository.updateProject(id, newProject);
      load();
      return result;
    } catch (e) {
      return Result.err(e.toString());
    }
  }

  Future<Result<String, String>> importProjectFromQr(
    String name,
    String code,
  ) async {
    final result = await _projectsRepository.addProjectWithCode(name, code);
    switch (result) {
      case Ok():
        load();
        return Result.ok(name);
      case Err():
        for (var i = 2; i <= 100; i++) {
          final altName = '$name ($i)';
          final retry = await _projectsRepository.addProjectWithCode(
            altName,
            code,
          );
          switch (retry) {
            case Ok():
              load();
              return Result.ok(altName);
            case Err():
              continue;
          }
        }
        return Result.err('Could not import project: ${result.error}');
    }
  }

  Future<Result<(), String>> deleteProject(String id) async {
    try {
      isLoaded = false;
      notifyListeners();
      await _projectsRepository.removeProject(id);
      load();
      return Result.ok(());
    } catch (e) {
      return Result.err(e.toString());
    }
  }
}
