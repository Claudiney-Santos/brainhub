import 'package:brainhub/models/project.dart';
import 'package:brainhub/repositories/projects_repository.dart';
import 'package:brainhub/utils/result.dart';
import 'package:flutter/material.dart';

class MenuViewModel extends ChangeNotifier {
  bool isLoaded = false;
  bool isSaved = false;
  List<Project> projects = [];
  final ProjectsRepository _projectsRepository;

  MenuViewModel({required ProjectsRepository projectsRepository})
    : _projectsRepository = projectsRepository;

  void load() async {
    projects = await _projectsRepository.loadProjects();
    isLoaded = true;
    notifyListeners();
  }

  Future<Result<(), String>> addProject(String projectName) async {
    if(_projectsRepository.getProjectByName(projectName) != null) {
      return Result.err('"$projectName" already exists.');
    }

    // projects = [...projects, Project(name: projectName, code: "")];
    isSaved = true;
    notifyListeners();

    await _projectsRepository.addProject(projectName);
    projects = await _projectsRepository.loadProjects();
    isSaved = false;
    notifyListeners();

    return Result.ok(());
  }

  Future<Result<(), String>> renameProject(int index, String newName) async {
    final oldProject = projects[index];
    final oldName = oldProject.name;

    if(oldName == newName) {
      return Result.ok(());
    }

    final newProject = Project(name: newName, code: oldProject.code);

    final result = await _projectsRepository.updateProject(oldProject, newProject);
    load();

    return result;
  }

  Future<Result<(), String>> deleteProject(int index) async {
    try {
      await _projectsRepository.removeProject(projects[index]);
      load();
      return Result.ok(());
    } catch(error) {
      return Result.err(error.toString());
    }
  }
}
