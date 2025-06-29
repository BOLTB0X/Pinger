import '../../domain/entities/generative_image.dart';
import '../../domain/repositories/image_repository.dart';
import '../datasources/remote_api_service.dart';
import '../../domain/models/generated_image.dart';
import 'dart:typed_data';

class ImageRepositoryImpl implements ImageRepository {
  final RemoteApiService apiService;

  ImageRepositoryImpl(this.apiService);

  @override
  Future<GenerativeImage?> generateFromSketch(
    String base64Sketch,
    String prompt,
  ) async {
    final result = await apiService.postImage(base64Sketch, prompt);
    return result != null ? GenerativeImage(result) : null;
  } // generateFromSketch

  @override
  Future<bool> saveGeneratedImage(
    Uint8List image,
    String prompt,
    String filename,
  ) async {
    return await apiService.postSaveImage(
      imageBytes: image,
      prompt: prompt,
      filename: filename,
    );
  } // saveGeneratedImage

  @override
  Future<List<GeneratedImage>> fetchGeneratedImageList({int limit = 10}) async {
    return await apiService.getGeneratedImageList(limit: limit);
  } // fetchImageMetadataList
} // ImageRepositoryImpl
