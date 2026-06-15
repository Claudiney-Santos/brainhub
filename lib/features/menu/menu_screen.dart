import 'dart:io';

import 'package:brainhub/features/menu/menu_viewmodel.dart';
import 'package:brainhub/utils/result.dart';
import 'package:brainhub/utils/qr_code_data.dart';
import 'package:brainhub/utils/qr_image_decoder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:brainhub/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:brainhub/widgets/project_list_item.dart';
import 'package:brainhub/models/project.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:brainhub/widgets/qr_scanner_dialog.dart';

class MenuScreen extends StatefulWidget {
  final MenuViewModel menuViewModel;

  const MenuScreen({super.key, required this.menuViewModel});

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
      if (!mounted) return;
      switch (result) {
        case Ok():
          break;
        case Err():
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(result.error)));
      }
    });

    Navigator.of(context).pop();
  }

  void _renameSketch(String id, String currentName) {
    final controller = TextEditingController(text: currentName);
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

  void _confirmRename(String id, String input) {
    final name = input.trim();
    if (name.isEmpty) return;

    widget.menuViewModel.renameProject(id, name).then((result) {
      if (!mounted) return;
      switch (result) {
        case Ok():
          break;
        case Err():
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(result.error)));
      }
    });

    Navigator.of(context).pop();
  }

  void _deleteSketch(String id) {
    widget.menuViewModel.deleteProject(id).then((result) {
      if (!mounted) return;
      switch (result) {
        case Ok():
          break;
        case Err():
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(result.error)));
      }
    });
  }

  void _showQr(BuildContext context, Project project) {
    final qrData = QrCodeData(
      name: project.name,
      code: project.code,
    ).toQrString();

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  project.name,
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 200,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  tooltip: 'Close',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showQrScanner(BuildContext context) {
    final isDesktop = !(Platform.isAndroid || Platform.isIOS);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Import QR Code',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              if (isDesktop)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Camera scanning is only available on mobile devices.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (!isDesktop)
                ListTile(
                  leading: Icon(
                    Icons.camera_alt_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  title: const Text('Scan with camera'),
                  trailing: const Icon(Icons.chevron_right),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _openCameraScanner();
                  },
                ),
              ListTile(
                leading: Icon(
                  Icons.image_rounded,
                  color: theme.colorScheme.primary,
                ),
                title: const Text('Import from image'),
                trailing: const Icon(Icons.chevron_right),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _pickQrFromImage();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _openCameraScanner() {
    showDialog(
      context: context,
      builder: (dialogContext) => QrScannerDialog(
        onDetected: (raw) {
          Navigator.of(dialogContext).pop();
          _processScannedQr(raw);
        },
      ),
    );
  }

  Future<void> _pickQrFromImage() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (result == null || result.files.single.bytes == null) return;

      final raw = decodeQrFromBytes(result.files.single.bytes!);
      if (raw == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No QR code found in the selected image.'),
          ),
        );
        return;
      }

      _processScannedQr(raw);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to read the image file.')),
      );
    }
  }

  void _processScannedQr(String raw) {
    final data = QrCodeData.fromQrString(raw);
    if (data == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid QR code. Not a BrainHub project.')),
      );
      return;
    }

    widget.menuViewModel
        .importProjectFromQr(data.name, data.code)
        .then((result) {
      if (!mounted) return;
      switch (result) {
        case Ok():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Imported "${result.value}"')),
          );
        case Err():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Import failed: ${result.error}')),
          );
      }
    });
  }

  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();
    if (!mounted) return;
    context.go(AppRouter.login);
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.menuViewModel;
    final theme = Theme.of(context);
    return ListenableBuilder(
      listenable: vm,
      builder: (context, child) {
        final projects = vm.projects;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.logout_outlined),
              onPressed: _logout,
            ),
            title: const Text('Projects'),
            actions: [
              IconButton(
                icon: const Icon(Icons.camera_alt_rounded),
                onPressed: () => _showQrScanner(context),
              ),
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
                    ? const Center(child: CircularProgressIndicator())
                    : projects.isEmpty
                    ? Center(
                        child: Text(
                          'No projects yet.',
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: projects.length,
                        itemBuilder: (context, index) {
                          final project = projects[index];
                          return ProjectListItem(
                            id: project.id,
                            project: project,
                            onRename: () =>
                                _renameSketch(project.id, project.name),
                            onDelete: () => _deleteSketch(project.id),
                            onOpen: () => context.push(
                              '${AppRouter.editor}?id=${project.id}',
                            ),
                            onShowQr: () => _showQr(context, project),
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
