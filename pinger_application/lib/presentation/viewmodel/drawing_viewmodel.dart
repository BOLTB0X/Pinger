import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../domain/usecases/generate_image_usecase.dart';
import '../../core/utils/image_utils.dart';

enum DrawingStatus { idle, loading, success, error }

class DrawingViewModel extends ChangeNotifier {
  GenerateImageUseCase generateImageUseCase;

  DrawingViewModel(this.generateImageUseCase);

  DrawingStatus status = DrawingStatus.idle;
  Uint8List? resultImage;

  Future<void> fetchGeneratedImage(GlobalKey key, String api) async {
    status = DrawingStatus.loading;

    notifyListeners();
    try {
      final base64 = await ImageUtils.extractAsBase64(key);
      final image = await generateImageUseCase(base64, api);

      if (image == null) {
        resultImage = null;
        status = DrawingStatus.error;
      } else {
        resultImage = image.imageBytes;
        status = DrawingStatus.success;
      }
    } catch (e) {
      print('ViewModel Error: $e');
      status = DrawingStatus.error;
      resultImage = null;
    }

    notifyListeners();
  } // fetchGeneratedImage
}
