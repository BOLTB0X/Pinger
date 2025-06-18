import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const ErrorDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("오류"),
      content: const Text("AI 이미지 생성 실패"),
      actions: [TextButton(onPressed: onConfirm, child: const Text("확인"))],
    );
  } // build
} // ErrorDialog
