import '../entities/generated_image.dart';
import '../models/generated_image_metadata.dart';
import 'dart:typed_data';

abstract class ImageRepository {
  Future<GeneratedImage?> generateFromSketch(
    String base64Sketch,
    String prompt,
  ); // generateFromSketch

  Future<bool> saveGeneratedImage(
    Uint8List image,
    String prompt,
    String filename,
  ); // saveGeneratedImage

  Future<List<GeneratedImageMetadata>> fetchImageMetadataList({
    int limit = 10,
  }); // fetchImageMetadataList
} // ImageRepository
