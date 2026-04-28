import 'package:flutter/material.dart';
import 'package:brainhub/models/project.dart';

class ProjectListItem extends StatelessWidget {
  final String id;
  final Project project;
  final VoidCallback onRename;
  final VoidCallback onDelete;
  final VoidCallback onOpen;
  final VoidCallback onShowQr;

  const ProjectListItem({
    super.key,
    required this.id,
    required this.project,
    required this.onRename,
    required this.onDelete,
    required this.onOpen,
    required this.onShowQr,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(project.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.qr_code), onPressed: onShowQr),
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: onRename,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: theme.colorScheme.error,
              onPressed: onDelete,
            ),
          ],
        ),
        onTap: onOpen,
      ),
    );
  }
}
