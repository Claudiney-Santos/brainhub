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
    isLoaded = false;
    projects = [];
    for(final project in (await _projectsRepository.loadProjects())) {
      projects.add(project);
    }
    isLoaded = true;
    notifyListeners();
  }

  Future<Result<(), String>> addProject(String projectName) async {
    if(_projectsRepository.getProjectByName(projectName) != null) {
      return Result.err('"$projectName" already exists.');
    }

    projects = [...projects, Project(name: projectName, code: "")];
    isLoaded = false;
    notifyListeners();

    await _projectsRepository.addProject(projectName);
    isLoaded = true;
    notifyListeners();

    return Result.ok(());
  }

  Future<Result<(), String>> renameProject(int index, String newName) async {
    try {
      final oldProject = projects[index];
      final oldName = oldProject.name;

      if(oldName == newName) {
        return Result.ok(());
      }

      final newProject = Project(name: newName, code: oldProject.code);

      projects = [
        ...projects.sublist(0, index),
        newProject,
        ...projects.sublist(index + 1),
      ];

      isLoaded = false;
      notifyListeners();

      final result = await _projectsRepository.updateProject(index, newProject);
      load();

      return result;
    } catch(e) {
      return Result.err(e.toString());
    }
  }

  Future<Result<(), String>> deleteProject(int index) async {
    try {
      projects = [
        ...projects.sublist(0, index),
        ...projects.sublist(index + 1),
      ];

      isLoaded = false;
      notifyListeners();

      await _projectsRepository.removeProject(index);
      load();
      return Result.ok(());
    } catch(error) {
      return Result.err(error.toString());
    }
  }
}
