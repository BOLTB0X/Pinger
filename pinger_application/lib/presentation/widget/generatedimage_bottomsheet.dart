import 'package:flutter/material.dart';
import 'dart:typed_data';

class GeneratedImageBottomSheet extends StatelessWidget {
  final Uint8List imageBytes;
  final VoidCallback onClose;

  const GeneratedImageBottomSheet({
    super.key,
    required this.imageBytes,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Generated image",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.memory(imageBytes),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onClose,
            icon: const Icon(Icons.close),
            label: const Text("닫기"),
          ),
        ],
      ),
    );
  } // build
}
