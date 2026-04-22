import 'package:brainhub/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:brainhub/widgets/code_editor_field.dart';
import 'package:brainhub/widgets/output_box.dart';
import 'package:go_router/go_router.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final TextEditingController _codeController = TextEditingController();
  String? _output;
  bool _showOutput = false;
  bool _isRunning = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _runCode() async {
    setState(() {
      _isRunning = true;
      _showOutput = false;
      _output = null;
    });

    final result = 'Code output'; // TODO: Code interpreter and output

    setState(() {
      _output = result;
      _showOutput = true;
      _isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRouter.menu),
        ),
        title: const Text('Editor'),
        actions: [
          _isRunning
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
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CodeEditorField(controller: _codeController),
              ),
            ),
          ),

          if (_showOutput && _output != null)
            OutputBox(
              output: _output!,
              onClose: () => setState(() => _showOutput = false),
            ),
        ],
      ),
    );
  }
}

