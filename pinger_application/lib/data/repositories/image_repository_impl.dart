import '../../domain/entities/generated_image.dart';
import '../../domain/repositories/image_repository.dart';
import '../datasources/remote_api_service.dart';

class ImageRepositoryImpl implements ImageRepository {
  final RemoteApiService apiService;

  ImageRepositoryImpl(this.apiService);

  @override
  Future<GeneratedImage?> generateFromSketch(
    String base64Sketch,
    String prompt,
    String api,
  ) async {
    final result = await apiService.postImage(base64Sketch, prompt, api);
    return result != null ? GeneratedImage(result) : null;
  }
}
