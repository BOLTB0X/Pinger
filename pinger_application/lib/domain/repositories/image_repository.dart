import '../entities/generated_image.dart';

abstract class ImageRepository {
  Future<GeneratedImage?> generateFromSketch(
    String base64Sketch,
    String prompt,
    String api,
  );
}
