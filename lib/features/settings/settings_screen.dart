import 'package:brainhub/features/settings/settings_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:brainhub/widgets/section_header.dart';
import 'package:brainhub/widgets/settings_card.dart';
import 'package:brainhub/widgets/slider_tile.dart';
import 'package:brainhub/widgets/stepper_tile.dart';
import 'package:brainhub/widgets/theme_tile.dart';

class SettingsScreen extends StatefulWidget {
  final SettingsViewModel settingsViewModel;

  const SettingsScreen({super.key, required this.settingsViewModel});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _updateFontSize(double newSize) {
    widget.settingsViewModel.updateFontSize(newSize);
  }

  void _updateTapeSize(int newSize) {
    widget.settingsViewModel.updateTapeSize(newSize);
  }

  void _updateStepLimit(int newLimit) {
    widget.settingsViewModel.updateStepLimit(newLimit);
  }

  void _updateThemeMode(ThemeMode newMode) {
    widget.settingsViewModel.updateThemeMode(newMode);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.settingsViewModel.loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.settingsViewModel;
    final theme = Theme.of(context);
    return ListenableBuilder(
      listenable: vm,
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: const Text('Settings'),
        ),
        body: !vm.isLoaded
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  SectionHeader(title: 'Editor'),
                  SettingsCard(
                    children: [
                      SliderTile(
                        icon: Icons.format_size,
                        label: 'Font Size',
                        value: vm.fontSize!,
                        min: 10,
                        max: 32,
                        divisions: 22,
                        display: vm.fontSize!.toInt().toString(),
                        onChanged: _updateFontSize,
                      ),
                      const Divider(height: 1),
                      StepperTile(
                        icon: Icons.memory,
                        label: 'Tape Size',
                        value: vm.tapeSize!,
                        step: 10000,
                        min: 1000,
                        max: 100000,
                        onChanged: _updateTapeSize,
                      ),
                      const Divider(height: 1),
                      StepperTile(
                        icon: Icons.loop,
                        label: 'Step Limit',
                        value: vm.stepLimit!,
                        step: 50000,
                        min: 10000,
                        max: 1000000,
                        onChanged: _updateStepLimit,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SectionHeader(title: 'Appearance'),
                  SettingsCard(
                    children: [
                      ThemeTile(
                        current: vm.themeMode!,
                        onChanged: _updateThemeMode,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SectionHeader(title: 'About'),
                  SettingsCard(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: const Text('Version'),
                        trailing: Text(
                          '1.0.0',
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.code),
                        title: const Text('Source Code'),
                        trailing: const Icon(Icons.open_in_new, size: 18),
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
