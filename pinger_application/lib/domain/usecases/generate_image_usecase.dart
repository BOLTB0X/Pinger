import '../entities/generated_image.dart';
import '../repositories/image_repository.dart';

class GenerateImageUseCase {
  final ImageRepository repository;

  GenerateImageUseCase({required this.repository});

  Future<GeneratedImage?> call(String base64, String prompt, String api) async {
    return await repository.generateFromSketch(base64, prompt, api);
  }
}
