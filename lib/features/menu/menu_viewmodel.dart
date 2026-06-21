import 'package:brainhub/models/project.dart';
import 'package:brainhub/repositories/hastebin_repository.dart';
import 'package:brainhub/repositories/projects_repository.dart';
import 'package:brainhub/utils/result.dart';
import 'package:flutter/material.dart';

class MenuViewModel extends ChangeNotifier {
  bool isLoaded = false;
  List<Project> projects = [];

  final ProjectsRepository _projectsRepository;
  final HastebinRepository _hastebinRepository;

  MenuViewModel({
    required ProjectsRepository projectsRepository,
    required HastebinRepository hastebinRepository,
  })  : _projectsRepository = projectsRepository,
        _hastebinRepository = hastebinRepository;

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

  Future<Result<String, String>> importFromHastebin(String keyOrUrl) async {
    final trimmed = keyOrUrl.trim();
    if (trimmed.isEmpty) return Result.err('Please provide a Hastebin URL or key.');

    final result = await _hastebinRepository.fetchPaste(trimmed);
    switch (result) {
      case Ok():
        final code = result.value;
        String name;
        if (trimmed.contains('://')) {
          final uri = Uri.tryParse(trimmed);
          final segments =
              uri?.pathSegments.where((s) => s.isNotEmpty).toList() ?? [];
          name = segments.isNotEmpty ? segments.last : 'Hastebin Import';
        } else {
          name = trimmed;
        }

        final addResult = await _projectsRepository.addProjectWithCode(
          name,
          code,
        );
        switch (addResult) {
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
            return Result.err('Could not import project: ${addResult.error}');
        }
      case Err():
        return Result.err(result.error);
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
