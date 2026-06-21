import 'package:brainhub/features/editor/editor_viewmodel.dart';
import 'package:brainhub/utils/result.dart';
import 'package:brainhub/widgets/input_editor_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brainhub/widgets/code_editor_field.dart';
import 'package:brainhub/widgets/output_box.dart';
import 'package:go_router/go_router.dart';

class EditorScreen extends StatefulWidget {
  final EditorViewModel editorViewModel;

  const EditorScreen({super.key, required this.editorViewModel});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _inputController = TextEditingController();
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();

    widget.editorViewModel.loadProject().then((_) {
      _codeController.text = widget.editorViewModel.code ?? '';
    });

    _codeController.addListener(_onCodeChanged);
    widget.editorViewModel.startAutoSaveTimer();
    _lifecycleListener = AppLifecycleListener(onInactive: _onAppInactive);
  }

  void _onCodeChanged() {
    widget.editorViewModel.updatePendingCode(_codeController.text);
  }

  Future<void> _onAppInactive() async {
    await widget.editorViewModel.saveIfNeeded();
  }

  Future<void> _goBack() async {
    await widget.editorViewModel.saveIfNeeded();
    if (mounted) context.pop();
  }

  void _shareViaHastebin() {
    widget.editorViewModel.shareViaHastebin().then((result) {
      if (!mounted) return;
      switch (result) {
        case Ok():
          final url = result.value;
          Clipboard.setData(ClipboardData(text: url));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Copied to clipboard: $url')),
          );
        case Err():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Share failed: ${result.error}')),
          );
      }
    });
  }

  void _runCode() {
    final script = _codeController.text;
    final input = _inputController.text;
    widget.editorViewModel.runCode(script, input).then((result) {
      if (!mounted) return;
      switch (result) {
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
      if (!mounted) return;
      switch (result) {
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
  void dispose() {
    _codeController.removeListener(_onCodeChanged);
    _codeController.dispose();
    _inputController.dispose();
    _lifecycleListener.dispose();
    super.dispose();
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
              onPressed: _goBack,
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [const Text('Editor')],
            ),
            actions: [
              if (vm.isDirty) ...[
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
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
              vm.isSharing
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
                      icon: const Icon(Icons.ios_share_rounded),
                      tooltip: 'Share via Hastebin',
                      onPressed: _shareViaHastebin,
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
              if (vm.showOutput && vm.output != null)
                OutputBox(output: vm.output!, onClose: () => vm.closeOutput()),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CodeEditorField(controller: _codeController),
                ),
              ),

              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 150),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: InputEditorField(controller: _inputController),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
