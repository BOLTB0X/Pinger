import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../domain/usecases/generate_image_usecase.dart';
import '../../domain/draw/drawing_manager.dart';
import '../../core/utils/image_utils.dart';

enum CanvasStatus { idle, loading, success, error }

class CanvasViewModel extends ChangeNotifier {
  DrawingManager drawingManager;
  GenerateImageUseCase generateImageUseCase;

  CanvasStatus status = CanvasStatus.idle;
  Uint8List? resultImage;

  final TextEditingController promptController = TextEditingController();

  String _prompt =
      "a peaceful village under sunset, anime style, vibrant colors";
  bool _showPrompt = false;
  bool _showSlider = false;

  bool _isPromptEmpty = false;
  bool _isErasing = false;
  double _strokeWidth = 4.0;
  bool _showEditBar = false;

  String get prompt => _prompt;
  bool get showPrompt => _showPrompt;
  bool get showSlider => _showSlider;
  bool get isPromptEmpty => _isPromptEmpty;
  bool get isErasing => _isErasing;
  double get strokeWidth => _strokeWidth;
  bool get isInputModeActive => _showPrompt || _showSlider;
  bool get showEditBar => _showEditBar;

  CanvasViewModel(this.drawingManager, this.generateImageUseCase) {
    promptController.text = _prompt;
  }

  // Methods
  // ...

  void togglePromptField() {
    _showPrompt = !_showPrompt;
    if (!_showPrompt) {
      _isPromptEmpty = promptController.text.trim().isEmpty;
    }
    notifyListeners();
  } // togglePromptField

  void toggleEditBar() {
    _showEditBar = !_showEditBar;
    notifyListeners();
  } // toggleEditBar

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

  void toggleEraser() {
    _isErasing = !_isErasing;
    drawingManager.eraseMode = _isErasing;
    notifyListeners();
  } // toggleEraser

  void toggleSlider() {
    _showSlider = !_showSlider;
    notifyListeners();
  } // toggleSlider

  void updateStrokeWidth(double value) {
    _strokeWidth = value;
    drawingManager.strokeWidth = _strokeWidth;
    notifyListeners();
  } // updateStrokeWidth

  Future<void> fetchGeneratedImage(GlobalKey key) async {
    status = CanvasStatus.loading;

    notifyListeners();

    try {
      final base64 = await ImageUtils.extractAsBase64(key);
      final image = await generateImageUseCase(base64, _prompt);

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
