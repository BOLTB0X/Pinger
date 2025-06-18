import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../domain/usecases/generate_image_usecase.dart';
import '../../domain/draw/drawing_manager.dart';
import '../../core/utils/image_utils.dart';

enum CanvasStatus { idle, loading, success, error }

class CanvasViewModel extends ChangeNotifier {
  DrawingManager drawingManager;
  GenerateImageUseCase generateImageUseCase;

  CanvasViewModel(this.drawingManager, this.generateImageUseCase);

  CanvasStatus status = CanvasStatus.idle;
  Uint8List? resultImage;

  final TextEditingController promptController = TextEditingController();

  String _prompt = "A cute god with wings";
  bool _showPrompt = false;
  bool _isPromptEmpty = false;

  String get prompt => _prompt;
  bool get showPrompt => _showPrompt;
  bool get isPromptEmpty => _isPromptEmpty;

  // Methods
  // ...

  void togglePromptField() {
    _showPrompt = !_showPrompt;
    if (!_showPrompt) {
      _isPromptEmpty = promptController.text.trim().isEmpty;
    }
    notifyListeners();
  } // togglePromptField

  void updatePrompt(String value) {
    _prompt = value;
    _isPromptEmpty = value.trim().isEmpty;
    notifyListeners();
  } // updatePrompt

  void resetPrompt() {
    _prompt = "";
    _isPromptEmpty = true;
    notifyListeners();
  } // resetPrompt

  void undo() {
    drawingManager.undo();
    notifyListeners();
  } // undo

  void redo() {
    drawingManager.redo();
    notifyListeners();
  } // redo

  void clear() {
    drawingManager.clear();
    notifyListeners();
  } // clear

  void resetStatus() {
    status = CanvasStatus.idle;
    notifyListeners();
  } // resetStatus

  Future<void> fetchGeneratedImage(GlobalKey key, String api) async {
    status = CanvasStatus.loading;

    notifyListeners();
    try {
      final base64 = await ImageUtils.extractAsBase64(key);
      final image = await generateImageUseCase(base64, api);

      if (image == null) {
        resultImage = null;
        status = CanvasStatus.error;
      } else {
        resultImage = image.imageBytes;
        status = CanvasStatus.success;
      }
    } catch (e) {
      print('ViewModel Error: $e');
      status = CanvasStatus.error;
      resultImage = null;
    }

    notifyListeners();
  } // fetchGeneratedImage
} // CanvasViewModel
