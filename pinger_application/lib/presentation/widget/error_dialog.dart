import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const ErrorDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text("Fail"),
      content: const Text("AI image creation failed"),
      actions: [TextButton(onPressed: onConfirm, child: const Text("OK"))],
    );
  } // build
} // ErrorDialog
