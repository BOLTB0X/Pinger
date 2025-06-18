import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../widget/error_dialog.dart';
import '../widget/generatedimage_bottomsheet.dart';
import '../widget/loading_dialog.dart';

extension CanvasDialogBuildContext on BuildContext {
  void showErrorDialog(VoidCallback onConfirm) {
    showDialog(
      context: this,
      builder: (_) => ErrorDialog(onConfirm: onConfirm),
    );
  } // showErrorDialog

  void showLoadingDialog() {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => const LoadingDialog(),
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
}
