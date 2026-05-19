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
