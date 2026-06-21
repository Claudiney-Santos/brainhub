import 'dart:async';
import 'package:brainhub/features/brainfuck_interpreter/brainfuck_interpreter.dart';
import 'package:brainhub/models/project.dart';
import 'package:brainhub/repositories/hastebin_repository.dart';
import 'package:brainhub/repositories/projects_repository.dart';
import 'package:brainhub/utils/result.dart';
import 'package:flutter/material.dart';

class EditorViewModel extends ChangeNotifier {
  final BrainfuckInterpreter brainfuckInterpreter;
  final ProjectsRepository projectsRepository;
  final HastebinRepository hastebinRepository;
  final String? projectId;

  Project? project;
  bool showOutput = false;
  bool _isRunning = false;
  bool _isSaving = false;
  bool _isSharing = false;
  bool _isDirty = false;
  String? _output;
  String? _pendingCode;
  Timer? _autoSaveTimer;

  bool get isRunning => _isRunning;
  bool get isSaving => _isSaving;
  bool get isSharing => _isSharing;
  bool get isDirty => _isDirty;
  String? get output => _output;
  String? get code => project?.code;
  String? get name => project?.name;

  EditorViewModel({
    required this.projectsRepository,
    required this.projectId,
    required this.brainfuckInterpreter,
    required this.hastebinRepository,
  });

  Future<void> loadProject() async {
    if (projectId == null) return;
    final projects = await projectsRepository.loadProjects();
    try {
      project = projects.firstWhere((p) => p.id == projectId);
    } catch (_) {
      project = null;
    }
    notifyListeners();
  }

  void startAutoSaveTimer() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      if (_pendingCode != null) {
        saveProject(_pendingCode!);
      }
    });
  }

  void updatePendingCode(String code) {
    _pendingCode = code;
    _isDirty = code != project?.code;
    notifyListeners();
  }

  Future<void> saveIfNeeded() async {
    if (_pendingCode == null) return;
    if (_pendingCode == project?.code) return;
    await saveProject(_pendingCode!);
  }

  Future<Result<(), String>> runCode(String script, String input) async {
    _isRunning = true;
    showOutput = false;
    notifyListeners();

    final result = await brainfuckInterpreter.run(script, input);
    switch (result) {
      case Ok():
        _output = result.value.isEmpty ? '[No output]' : result.value;
      case Err():
        _output = 'Error: ${result.error.message}';
    }

    _isRunning = false;
    showOutput = true;
    notifyListeners();
    return Result.ok(());
  }

  Future<Result<(), String>> saveProject(String newCode) async {
    if (project == null) return Result.err('No project loaded.');

    _isSaving = true;
    notifyListeners();

    final updatedProject = project!.copyWith(code: newCode);
    final result = await projectsRepository.updateProject(
      projectId!,
      updatedProject,
    );

    if (result is Ok) {
      project = updatedProject;
      _pendingCode = null;
      _isDirty = false;
    }

    _isSaving = false;
    notifyListeners();
    return result;
  }

  Future<Result<String, String>> shareViaHastebin() async {
    final codeToShare = _pendingCode ?? project?.code ?? '';
    if (codeToShare.isEmpty) return Result.err('No code to share.');

    _isSharing = true;
    notifyListeners();

    final result = await hastebinRepository.createPaste(codeToShare);

    _isSharing = false;
    notifyListeners();
    return result;
  }

  void closeOutput() {
    showOutput = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    super.dispose();
  }
}
