import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../domain/usecases/save_image_usecase.dart';
import '../../domain/models/sketch.dart';

enum SaveStatus { idle, saving, success, error }

class ResultViewModel extends ChangeNotifier {
  final SaveImageUseCase saveImageUseCase;

  String _fileName = "image_${DateTime.now().millisecondsSinceEpoch}";
  bool _isFileNameEmpty = false;
  bool _isSaving = false;
  bool _showTitleField = false;
  SaveStatus _status = SaveStatus.idle;

  String get fileName => _fileName;
  bool get isFileNameEmpty => _isFileNameEmpty;
  bool get isSaving => _isSaving;
  bool get showTitleField => _showTitleField;
  SaveStatus get status => _status;

  final TextEditingController titleController = TextEditingController();

  ResultViewModel({required this.saveImageUseCase}) {
    titleController.text = _fileName;
  }

  void toggleTitleField() {
    _showTitleField = !_showTitleField;
    notifyListeners();
  } // toggleTitleField

  void resetStatus() {
    _status = SaveStatus.idle;
    notifyListeners();
  } // resetStatus

  void updateFileName(String value) {
    _fileName = value;
    _isFileNameEmpty = value.trim().isEmpty;
    notifyListeners();
  } // updateFileName

  void resetFileName() {
    _fileName = "";
    _isFileNameEmpty = true;
    notifyListeners();
  } // resetFileName

  Future<void> requestSave(
    Uint8List imageBytes,
    String prompt,
    String filename,
    List<Sketch> sketches,
  ) async {
    if (_isSaving) return;

    _isSaving = true;
    _status = SaveStatus.saving;
    notifyListeners();

    try {
      final success = await saveImageUseCase(
        imageBytes,
        prompt,
        filename,
        sketches,
      );

      _status = success ? SaveStatus.success : SaveStatus.error;
    } catch (e, stackTrace) {
      print("Save error: $e");
      print(stackTrace);
      _status = SaveStatus.error;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
} // ResultViewModel
