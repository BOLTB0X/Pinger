import '../entities/generative_image.dart';
import '../models/generated_image.dart';
import 'dart:typed_data';

abstract class ImageRepository {
  Future<GenerativeImage?> generateFromSketch(
    String base64Sketch,
    String prompt,
  ); // generateFromSketch

  Future<bool> saveGeneratedImage(
    Uint8List image,
    String prompt,
    String filename,
  ); // saveGeneratedImage

  Future<List<GeneratedImage>> fetchGeneratedImageList({
    int limit = 10,
  }); // fetchGeneratedImageList
} // ImageRepository
