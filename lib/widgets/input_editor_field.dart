import 'package:brainhub/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InputEditorField extends StatelessWidget {
  final TextEditingController controller;

  const InputEditorField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = context.read<SettingsRepository>();
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: null,
        expands: true,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontSize: settings.fontSize,
          fontFamily: 'monospace',
          letterSpacing: 1.5,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16),
          border: InputBorder.none,
          hintText: "Insert input here...",
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
      ),
    );
  }
}
