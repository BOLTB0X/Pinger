import '../entities/generative_image.dart';
import '../repositories/image_repository.dart';

class GenerateImageUseCase {
  final ImageRepository repository;

  GenerateImageUseCase({required this.repository});

  Future<GenerativeImage?> call(String base64, String prompt) async {
    return await repository.generateFromSketch(base64, prompt);
  }
}
