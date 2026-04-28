import 'package:brainhub/features/brainfuck_interpreter/brainfuck_interpreter.dart';
import 'package:brainhub/models/project.dart';
import 'package:brainhub/repositories/projects_repository.dart';
import 'package:brainhub/utils/result.dart';
import 'package:flutter/material.dart';

class EditorViewModel extends ChangeNotifier {
  final BrainfuckInterpreter brainfuckInterpreter;
  final ProjectsRepository projectsRepository;
  final String? projectId;
  Project? project;
  bool showOutput = false;
  bool _isRunning = false;
  bool _isSaving = false;
  String? _output;

  bool get isRunning => _isRunning;
  bool get isSaving => _isSaving;
  String? get output => _output;

  EditorViewModel({
    required this.projectsRepository,
    required this.projectId,
    required this.brainfuckInterpreter,
  });

  String? get code => project?.code;
  String? get name => project?.name;

  Future<void> loadProject() async {
    if(projectId == null) {
      return;
    }

    project = await projectsRepository.getProjectById(projectId!);
    notifyListeners();
  }

  Future<Result<(), String>> runCode(String script) async {
    _isRunning = true;
    showOutput = false;
    notifyListeners();

    final result = await brainfuckInterpreter.run(script);

    switch(result) {
      case Ok():
        _output = result.value;
        break;
      case Err():
        _output = 'Error: ${result.error}';
        break;
    }

    _isRunning = false;
    showOutput = true;
    notifyListeners();

    return Result.ok(());
  }

  Future<Result<(), String>> saveProject(String newCode) async {
    if(project == null) {
      return Result.err('No project loaded.');
    }

    _isSaving = true;
    notifyListeners();

    final updatedProject = Project(name: project!.name, code: newCode);
    await projectsRepository.updateProject(projectId!, updatedProject);
    project = updatedProject;

    _isSaving = false;
    notifyListeners();
    print('Project saved: ${project!.name}');

    return Result.ok(());
  }
}
