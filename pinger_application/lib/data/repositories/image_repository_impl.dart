import '../datasources/remote_api_service.dart';
import '../../domain/entities/generative_image.dart';
import '../../domain/repositories/image_repository.dart';
import '../../domain/models/generated_image.dart';
import '../../domain/models/sketch.dart';
import '../../core/utils/sketch_utils.dart';
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
    List<Sketch> sketches,
  ) async {
    return await apiService.postSaveImage(
      imageBytes: image,
      prompt: prompt,
      filename: filename,
      sketches: SketchUtils().toDtoList(sketches),
    );
  } // saveGeneratedImage

  @override
  Future<List<GeneratedImage>> fetchGeneratedImageList({int limit = 10}) async {
    final dtoList = await apiService.getGeneratedImageList(limit: limit);
    return dtoList.map((dto) => dto.toDomain()).toList();
  } // fetchGeneratedImageList
} // ImageRepositoryImpl
