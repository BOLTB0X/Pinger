import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      backgroundColor: Colors.white,
      content: Row(
        children: [
          CircularProgressIndicator(backgroundColor: Colors.blue),
          SizedBox(width: 16),
          Text("Creating image..."),
        ],
      ),
    );
  } // build
} // LoadingDialog
