import 'dart:collection';

import 'package:brainhub/models/project.dart';
import 'package:brainhub/repositories/projects_repository.dart';
import 'package:brainhub/utils/pair.dart';
import 'package:brainhub/utils/result.dart';
import 'package:flutter/material.dart';

class MenuViewModel extends ChangeNotifier {
  bool isLoaded = false;
  HashMap<String, Project> projects = HashMap();
  final ProjectsRepository _projectsRepository;

  MenuViewModel({required ProjectsRepository projectsRepository})
    : _projectsRepository = projectsRepository;

  List<Pair<String, Project>> get projectsList =>
    projects.entries.map((entry) => Pair(entry.key, entry.value)).toList();

  void load() async {
    isLoaded = false;
    projects = HashMap();
    final projectsMap = await _projectsRepository.loadProjects();
    for(final id in projectsMap.keys) {
      projects[id] = projectsMap[id]!;
    }
    isLoaded = true;
    print('Loaded projects: ${projects.keys.join(', ')}');
    notifyListeners();
  }

  Future<Result<(), String>> addProject(String projectName) async {
    if(_projectsRepository.getProjectByName(projectName) != null) {
      return Result.err('"$projectName" already exists.');
    }

    isLoaded = false;
    notifyListeners();

    await _projectsRepository.addProject(projectName);
    load();

    return Result.ok(());
  }

  Future<Result<(), String>> renameProject(String id, String newName) async {
    try {
      final oldProject = projects[id]!;
      final oldName = oldProject.name;

      if(oldName == newName) {
        return Result.ok(());
      }

      final newProject = Project(name: newName, code: oldProject.code);

      isLoaded = false;
      notifyListeners();

      final result = await _projectsRepository.updateProject(id, newProject);
      load();

      return result;
    } catch(e) {
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
    } catch(error) {
      return Result.err(error.toString());
    }
  }
}
