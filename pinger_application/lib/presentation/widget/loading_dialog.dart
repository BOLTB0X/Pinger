import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final String content;

  const LoadingDialog({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Row(
        children: [
          CircularProgressIndicator(backgroundColor: Colors.blue),
          SizedBox(width: 16),
          Text(content),
        ],
      ),
    );
  } // build
} // LoadingDialog
