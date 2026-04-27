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

  void _renameSketch(String id) {
    final controller = TextEditingController(text: widget.menuViewModel.projects[id]!.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Project'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Project name'),
          onSubmitted: (_) => _confirmRename(id, controller.text),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _confirmRename(id, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmRename(String id, String input) async {
    final name = input.trim();
    if (name.isEmpty) return;

    widget.menuViewModel.renameProject(id, name).then((result) {
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

  void _deleteSketch(String id) async {
    widget.menuViewModel.deleteProject(id).then((result) {
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
    final theme = Theme.of(context);
    return ListenableBuilder(
      listenable: vm,
      builder: (context, child) {
        final projects = vm.projectsList;
        print('Building MenuScreen with projects: ${projects.map((p) => p.second.name).join(', ')}');
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.logout_outlined),
              onPressed: () => context.go(AppRouter.login),
            ),
            title: const Text('Projects'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => context.push(AppRouter.settings),
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
                  : projects.isEmpty
                    ? Center(
                        child: Text(
                          'No projects yet.',
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: projects.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
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
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: Text(projects[index].second.name),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined),
                                    onPressed: () => _renameSketch(projects[index].first),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    color: theme.colorScheme.error,
                                    onPressed: () => _deleteSketch(projects[index].first),
                                  ),
                                ],
                              ),
                              onTap: () => context.push("${AppRouter.editor}?id=${projects[index].first}"),
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
