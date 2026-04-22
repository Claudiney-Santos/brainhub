import 'package:flutter/material.dart';

class StepperTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final int step;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const StepperTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.step,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: value <= min
                ? null
                : () => onChanged((value - step).clamp(min, max)),
          ),
          Text(
            value >= 1000 ? '${(value / 1000).toStringAsFixed(0)}k' : '$value',
            style: const TextStyle(color: Colors.grey),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: value >= max
                ? null
                : () => onChanged((value + step).clamp(min, max)),
          ),
        ],
      ),
    );
  }
}
