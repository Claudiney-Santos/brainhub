import 'dart:collection';

import 'package:brainhub/models/project.dart';
import 'package:brainhub/utils/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProjectsRepository {
  final _client = Supabase.instance.client;
  static const _table = 'projects';

  String get _userId => _client.auth.currentUser!.id;

  Future<UnmodifiableListView<Project>> loadProjects() async {
    final data = await _client
        .from(_table)
        .select()
        .eq('user_id', _userId)
        .eq('is_deleted', false)
        .order('created_at');

    final projects = (data as List).map((e) => Project.fromMap(e)).toList();
    return UnmodifiableListView(projects);
  }

  Project? getProjectByName(List<Project> projects, String name) {
    try {
      return projects.firstWhere((p) => p.name == name);
    } catch (_) {
      return null;
    }
  }

  Future<Result<(), String>> addProject(String projectName) async {
    try {
      final existing = await _client
          .from(_table)
          .select()
          .eq('user_id', _userId)
          .eq('name', projectName)
          .eq('is_deleted', false)
          .maybeSingle();

      if (existing != null) {
        return Result.err('Project with the same name already exists');
      }

      await _client.from(_table).insert({
        'user_id': _userId,
        'name': projectName,
        'code': '',
        'is_deleted': false,
      });

      return Result.ok(());
    } catch (e) {
      return Result.err(e.toString());
    }
  }

  Future<void> removeProject(String id) async {
    await _client.from(_table).update({'is_deleted': true}).eq('id', id);
  }

  Future<Result<(), String>> updateProject(
    String id,
    Project newProject,
  ) async {
    try {
      final existing = await _client
          .from(_table)
          .select()
          .eq('user_id', _userId)
          .eq('name', newProject.name)
          .eq('is_deleted', false)
          .neq('id', id)
          .maybeSingle();

      if (existing != null) {
        return Result.err('"${newProject.name}" already exists');
      }

      await _client
          .from(_table)
          .update({'name': newProject.name, 'code': newProject.code})
          .eq('id', id);

      return Result.ok(());
    } catch (e) {
      return Result.err(e.toString());
    }
  }
}
