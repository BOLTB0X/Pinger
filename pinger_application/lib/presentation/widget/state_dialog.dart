import 'package:flutter/material.dart';

class StateDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;

  const StateDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: onConfirm,
          child: const Text("OK", style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  } // build
} // ErrorDialog
