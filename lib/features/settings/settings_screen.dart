import 'package:brainhub/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:brainhub/widgets/section_header.dart';
import 'package:brainhub/widgets/settings_card.dart';
import 'package:brainhub/widgets/slider_tile.dart';
import 'package:brainhub/widgets/stepper_tile.dart';
import 'package:brainhub/widgets/theme_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _fontSize = 18;
  int _tapeSize = 30000;
  int _stepLimit = 100000;
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRouter.menu),
        ),
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionHeader(title: 'Editor'),
          SettingsCard(
            children: [
              SliderTile(
                icon: Icons.format_size,
                label: 'Font Size',
                value: _fontSize,
                min: 10,
                max: 32,
                divisions: 22,
                display: _fontSize.toInt().toString(),
                onChanged: (v) => setState(() => _fontSize = v),
              ),
              const Divider(height: 1),
              StepperTile(
                icon: Icons.memory,
                label: 'Tape Size',
                value: _tapeSize,
                step: 10000,
                min: 1000,
                max: 100000,
                onChanged: (v) => setState(() => _tapeSize = v),
              ),
              const Divider(height: 1),
              StepperTile(
                icon: Icons.loop,
                label: 'Step Limit',
                value: _stepLimit,
                step: 50000,
                min: 10000,
                max: 1000000,
                onChanged: (v) => setState(() => _stepLimit = v),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SectionHeader(title: 'Appearance'),
          SettingsCard(
            children: [
              ThemeTile(
                current: _themeMode,
                onChanged: (v) => setState(() => _themeMode = v),
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
                trailing: const Text(
                  '1.0.0',
                  style: TextStyle(color: Colors.grey),
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
    );
  }
}
