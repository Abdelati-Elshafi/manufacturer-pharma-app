// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:mobile_scanner/mobile_scanner.dart'; // For barcode scanning
import 'dart:typed_data'; // For storing image bytes

class SingleShotBarcodeScanner extends StatefulWidget {
  const SingleShotBarcodeScanner({
    Key? key,
    this.width, // Width of the scanner widget
    this.height, // Height of the scanner widget
    this.lastScannedCodes, // List of previously scanned codes to prevent duplicates
    this.onScanAction, // Callback when a new code is scanned
  }) : super(key: key);

  final double? width;
  final double? height;
  final List<String>? lastScannedCodes;
  final Future<void> Function(String scannedCode)? onScanAction;

  @override
  State<SingleShotBarcodeScanner> createState() =>
      _SingleShotBarcodeScannerState();
}

class _SingleShotBarcodeScannerState extends State<SingleShotBarcodeScanner> {
  late MobileScannerController _controller; // Controller for MobileScanner
  bool _isScanning = false; // Whether we are currently scanning
  Uint8List? _lastFrame; // Last frame image from the camera
  bool _dialogOpen = false; // Prevent opening multiple dialogs at the same time

  @override
  void initState() {
    super.initState();
    _initController(); // Initialize scanner controller on widget start
  }

  // Create a new MobileScannerController instance
  void _initController() {
    _controller = MobileScannerController();
  }

  // Start a new scan
  Future<void> _startScan() async {
    _controller.dispose(); // Dispose of the old controller
    _initController(); // Create a new one to avoid camera freeze
    setState(() {
      _isScanning = true; // Mark scanning as active
      _lastFrame = null; // Reset last frame image
    });
  }

  // This function is called when a barcode is detected
  void _onDetect(BarcodeCapture capture) async {
    // If scanning is not active, ignore
    if (!_isScanning) return;

    // Get the first barcode value
    final code = capture.barcodes.first.rawValue;
    // Ignore if code is null or empty
    if (code == null || code.isEmpty) return;

    // Save last camera frame image
    if (capture.image != null) {
      _lastFrame = capture.image!;
    }

    // Stop scanning until user starts again
    setState(() => _isScanning = false);

    // Check for duplicate codes
    if (widget.lastScannedCodes != null &&
        widget.lastScannedCodes!.contains(code)) {
      // Show dialog only if not already open
      if (!_dialogOpen && mounted) {
        _dialogOpen = true;
        // Delay showing the dialog until after current frame is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Duplicate Code'),
              content: Text('This code has already been scanned: $code'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    _dialogOpen = false; // Allow opening dialog again
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        });
      }
      return; // Exit without processing this code further
    }

    // If new code, run the provided callback
    if (widget.onScanAction != null) {
      await widget.onScanAction!(code);
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Release camera resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity, // Default to full width
      height: widget.height ?? 400, // Default height
      child: Column(
        children: [
          SizedBox(
            width: widget.width ?? double.infinity,
            height: widget.height != null ? widget.height! * 0.8 : 320,
            // Show camera if scanning, otherwise show last captured frame
            child: _isScanning
                ? MobileScanner(
                    controller: _controller,
                    onDetect: _onDetect, // Handle barcode detection
                  )
                : (_lastFrame != null
                    ? Image.memory(
                        _lastFrame!,
                        fit: BoxFit.cover, // Fit image to container
                      )
                    : const SizedBox.shrink()), // Empty placeholder
          ),
          const Spacer(), // Push button to bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Center(
              // Button to start a new scan
              child: ElevatedButton(
                onPressed: _startScan,
                child: const Text('Scan New'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
