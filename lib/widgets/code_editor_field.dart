import 'package:flutter/material.dart';

class CodeEditorField extends StatelessWidget {
  final TextEditingController controller;

  const CodeEditorField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: null,
      expands: true,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'monospace',
        fontSize: 18,
        letterSpacing: 2,
      ),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.all(16),
        border: InputBorder.none,
        hintText: 'Write Brainfuck code here...',
        hintStyle: TextStyle(color: Colors.white24),
      ),
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
    );
  }
}
