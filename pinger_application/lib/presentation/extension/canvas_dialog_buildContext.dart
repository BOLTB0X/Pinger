import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../widget/state_dialog.dart';
import '../widget/generated_image_bottomsheet.dart';
import '../widget/loading_dialog.dart';

extension CanvasDialogBuildContext on BuildContext {
  void showStateDialog(String title, String content, VoidCallback onConfirm) {
    showDialog(
      context: this,
      builder: (_) =>
          StateDialog(title: title, content: content, onConfirm: onConfirm),
    );
  } // showErrorDialog

  void showLoadingDialog(String content) {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => LoadingDialog(content: content),
    );
  } // showLoadingDialog

  void showGeneratedImageBottomSheet(
    Uint8List imageBytes,
    VoidCallback onClose,
  ) {
    showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) =>
          GeneratedImageBottomSheet(imageBytes: imageBytes, onClose: onClose),
    );
  } // showGeneratedImageBottomSheet

  Future<bool?> showConfirmDialog({
    required String title,
    required String content,
    String cancelText = 'Cancel',
    String confirmText = 'Delete',
  }) {
    return showDialog<bool>(
      context: this,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(this, false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.pop(this, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  } // showConfirmDialog
} // CanvasDialogBuildContext
