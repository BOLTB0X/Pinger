import '../repositories/image_repository.dart';
import '../models/sketch.dart';
import 'dart:typed_data';

class SaveImageUseCase {
  final ImageRepository repository;

  SaveImageUseCase({required this.repository});

  Future<bool> call(
    Uint8List image,
    String prompt,
    String filename,
    List<Sketch> sketches,
  ) async {
    return await repository.saveGeneratedImage(
      image,
      prompt,
      filename,
      sketches,
    );
  } // call
} // SaveImageUseCase
