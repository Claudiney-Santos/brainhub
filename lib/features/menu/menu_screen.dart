import 'package:brainhub/features/menu/menu_viewmodel.dart';
import 'package:brainhub/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:brainhub/models/project.dart';
import 'package:brainhub/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  final MenuViewModel menuViewModel;

  MenuScreen({super.key, required this.menuViewModel});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    widget.menuViewModel.load();
  }

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

  Future<void> _confirmAdd(String input) async {
    final name = input.trim();
    if (name.isEmpty) return;

    widget.menuViewModel.addProject(name).then((result) {
      switch(result) {
        case Ok():
          break;
        case Err():
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(result.error)));
          break;
      }
    });

    Navigator.of(context).pop();
  }

  void _renameSketch(int index) {
    final controller = TextEditingController(text: widget.menuViewModel.projects[index].name);
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

  void _confirmRename(int index, String input) async {
    final name = input.trim();
    if (name.isEmpty) return;

    widget.menuViewModel.renameProject(index, name).then((result) {
      switch(result) {
        case Ok():
          break;
        case Err():
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(result.error)));
          break;
      }
    });

    Navigator.of(context).pop();
  }

  void _deleteSketch(int index) async {
    widget.menuViewModel.deleteProject(index).then((result) {
      switch(result) {
        case Ok():
          break;
        case Err():
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(result.error)));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.menuViewModel;
    return ListenableBuilder(
      listenable: widget.menuViewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Projects'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => context.go(AppRouter.settings),
              ),
            ],
          ),
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
                child: !vm.isLoaded
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : vm.projects.isEmpty
                    ? const Center(
                        child: Text(
                          'No projects yet.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: vm.projects.length,
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
                              title: Text(vm.projects[index].name),
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
      },
    );
  }
}
