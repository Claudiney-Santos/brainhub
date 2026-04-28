import 'package:brainhub/features/editor/editor_viewmodel.dart';
import 'package:brainhub/router/app_router.dart';
import 'package:brainhub/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:brainhub/widgets/code_editor_field.dart';
import 'package:brainhub/widgets/output_box.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EditorScreen extends StatefulWidget {
  final EditorViewModel editorViewModel;

  const EditorScreen({super.key, required this.editorViewModel});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final TextEditingController _codeController = TextEditingController();

  void initState() {
    super.initState();
    widget.editorViewModel.loadProject().then((_) {
      _codeController.text = widget.editorViewModel.code ?? '';
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _runCode() {
    final script = _codeController.text;
    widget.editorViewModel.runCode(script).then((result) {
      switch(result) {
        case Ok():
          break;
        case Err():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to run code: ${result.error}')),
          );
          break;
      }
    });
  }

  void _saveProject(String newCode) {
    widget.editorViewModel.saveProject(newCode).then((result) {
      switch(result) {
        case Ok():
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Project saved successfully!')),
          );
          break;
        case Err():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save project: ${result.error}')),
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.editorViewModel;
    return ListenableBuilder(
      listenable: vm,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            title: const Text('Editor'),
            actions: [
              vm.isSaving
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.save_rounded),
                      tooltip: 'Save',
                      onPressed: () => _saveProject(_codeController.text),
                    ),
              vm.isRunning
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.play_arrow_rounded),
                      tooltip: 'Run',
                      onPressed: _runCode,
                    ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CodeEditorField(controller: _codeController),
                ),
              ),

              if (vm.showOutput && vm.output != null)
                OutputBox(
                  output: vm.output!,
                  onClose: () => vm.closeOutput(),
                ),
            ],
          ),
        );
      }
    );
  }
}

