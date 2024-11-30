import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerWidget extends StatelessWidget {
  final Function(String) onScan;

  const QRScannerWidget({super.key, required this.onScan});

  @override
  Widget build(BuildContext context) {
    final MobileScannerController scannerController = MobileScannerController();

    return Stack(
      children: [
        // Full-screen camera view
        MobileScanner(
          controller: scannerController,
          onDetect: (barcodeCapture) {
            if (barcodeCapture.barcodes.isNotEmpty) {
              final barcode = barcodeCapture.barcodes.first;
              if (barcode.rawValue != null) {
                onScan(barcode.rawValue!);
              } else {
                _showErrorSnackbar(context, 'Failed to detect QR code.');
              }
            }
          },
          errorBuilder: (context, error, _) {
            return Center(
              child: Text(
                'Camera error: ${error.toString()}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          },
        ),
        // Overlay for scan guidance
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        // Flashlight toggle button
        Positioned(
          top: 40,
          right: 16,
          child: FlashToggleButton(controller: scannerController),
        ),
      ],
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class FlashToggleButton extends StatefulWidget {
  final MobileScannerController controller;

  const FlashToggleButton({super.key, required this.controller});

  @override
  State<FlashToggleButton> createState() => _FlashToggleButtonState();
}

class _FlashToggleButtonState extends State<FlashToggleButton> {
  bool isFlashOn = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFlashOn ? Icons.flash_on : Icons.flash_off,
        color: Colors.white,
      ),
      onPressed: () async {
        try {
          await widget.controller.toggleTorch();
          setState(() {
            isFlashOn = !isFlashOn;
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Flashlight error: ${e.toString()}')),
          );
        }
      },
    );
  }
}