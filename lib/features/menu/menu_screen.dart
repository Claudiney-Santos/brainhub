import 'package:flutter/material.dart';
import 'package:brainhub/models/project.dart';
import 'package:brainhub/router/app_router.dart';
import 'package:go_router/go_router.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final List<Project> _projects = [];

  void _addSketch() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Project'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Project name'),
          onSubmitted: (_) => _confirmAdd(controller.text),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _confirmAdd(controller.text),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _confirmAdd(String input) {
    final name = input.trim();
    if (name.isEmpty) return;

    final alreadyExists = _projects.any((s) => s.name == name);
    if (alreadyExists) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('"$name" already exists.')));
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _projects.insert(0, Project(name: name));
    });
    Navigator.of(context).pop();
  }

  void _renameSketch(int index) {
    final controller = TextEditingController(text: _projects[index].name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Project'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Project name'),
          onSubmitted: (_) => _confirmRename(index, controller.text),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _confirmRename(index, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmRename(int index, String input) {
    final name = input.trim();
    if (name.isEmpty) return;

    if (name == _projects[index].name) {
      Navigator.of(context).pop();
      return;
    }

    final alreadyExists = _projects.any((s) => s.name == name);
    if (alreadyExists) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('"$name" already exists.')));
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _projects[index].name = name;
    });
    Navigator.of(context).pop();
  }

  void _deleteSketch(int index) {
    setState(() {
      _projects.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Projects')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addSketch,
                icon: const Icon(Icons.add),
                label: const Text('New Project'),
              ),
            ),
          ),
          Expanded(
            child: _projects.isEmpty
                ? const Center(
                    child: Text(
                      'No projects yet.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _projects.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: Text(_projects[index].name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () => _renameSketch(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                color: Colors.redAccent,
                                onPressed: () => _deleteSketch(index),
                              ),
                            ],
                          ),
                          onTap: () => context.go(AppRouter.editor),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
