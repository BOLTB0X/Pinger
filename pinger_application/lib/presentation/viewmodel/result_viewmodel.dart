import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../domain/usecases/save_image_usecase.dart';

class ResultViewModel extends ChangeNotifier {
  final SaveImageUseCase saveImageUseCase;

  bool _isSaving = false;
  bool _showTitleField = false;

  bool get isSaving => _isSaving;
  bool get showTitleField => _showTitleField;

  ResultViewModel(this.saveImageUseCase);
  final TextEditingController titleController = TextEditingController();

  void toggleTitleField() {
    _showTitleField = !_showTitleField;
    notifyListeners();
  } // toggleTitleField

  Future<void> requestSave(
    Uint8List imageBytes,
    String prompt,
    String filename,
    VoidCallback onSuccess,
    VoidCallback onFailure,
  ) async {
    _isSaving = true;
    notifyListeners();

    final result = await saveImageUseCase(imageBytes, prompt, filename);

    _isSaving = false;
    notifyListeners();

    if (result) {
      onSuccess();
    } else {
      onFailure();
    } // if - else
  } // requestSave
} // ResultViewModel
