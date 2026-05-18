import 'dart:collection';

import 'package:brainhub/models/project.dart';
import 'package:brainhub/utils/id_generator.dart';
import 'package:brainhub/utils/result.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class ProjectsRepository {
  static const _boxName = 'projects';

  late final Box<Project> _box;

  Future<void> init() async {
    _box = await Hive.openBox<Project>(_boxName);
  }

  UnmodifiableMapView<String, Project> get projects => UnmodifiableMapView(
    Map.fromEntries(
      _box.keys.cast<String>().map((k) => MapEntry(k, _box.get(k)!)),
    ),
  );

  Project? getProjectById(String id) => _box.get(id);

  Project? getProjectByName(String name) {
    try {
      return _box.values.firstWhere((p) => p.name == name);
    } catch (_) {
      return null;
    }
  }

  Future<UnmodifiableMapView<String, Project>> loadProjects() async {
    return projects;
  }

  Future<Result<(), String>> addProject(String projectName) async {
    if (getProjectByName(projectName) != null) {
      return Result.err('Project with the same name already exists');
    }
    final id = IdGenerator.generateId();
    await _box.put(id, Project(name: projectName, code: ''));
    return Result.ok(());
  }

  Future<void> removeProject(String id) async {
    await _box.delete(id);
  }

  Future<Result<(), String>> updateProject(
    String id,
    Project newProject,
  ) async {
    try {
      final oldProject = _box.get(id);
      if (oldProject == null) return Result.err('Project not found');

      final oldName = oldProject.name;
      final newName = newProject.name;
      if (oldName != newName && _box.values.any((p) => p.name == newName)) {
        return Result.err('"$newName" already exists');
      }

      await _box.put(id, newProject);
      return Result.ok(());
    } catch (e) {
      return Result.err(e.toString());
    }
  }
}

