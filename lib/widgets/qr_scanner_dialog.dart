import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerDialog extends StatefulWidget {
  final void Function(String raw) onDetected;

  const QrScannerDialog({super.key, required this.onDetected});

  @override
  State<QrScannerDialog> createState() => QrScannerDialogState();
}

class QrScannerDialogState extends State<QrScannerDialog> {
  final MobileScannerController controller = MobileScannerController();
  bool _hasDetected = false;

  @override
  void dispose() { controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.qr_code_scanner,
              size: 40,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 260,
              height: 260,
              child: ClipRRect( borderRadius: BorderRadius.circular(16),
                child: MobileScanner(
                  controller: controller,
                  onDetect: (capture) {
                    if (_hasDetected) return;
                    final barcode = capture.barcodes.first;
                    if (barcode.rawValue != null) {
                      _hasDetected = true;
                      widget.onDetected(barcode.rawValue!);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ),
    );
  }
}
