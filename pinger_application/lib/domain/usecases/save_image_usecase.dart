import '../repositories/image_repository.dart';
import 'dart:typed_data';

class SaveImageUseCase {
  final ImageRepository repository;

  SaveImageUseCase({required this.repository});

  Future<bool> call(Uint8List image, String prompt, String filename) async {
    return await repository.saveGeneratedImage(image, prompt, filename);
  }
}
