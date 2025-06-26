import '../entities/generated_image.dart';
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
} // ImageRepository
