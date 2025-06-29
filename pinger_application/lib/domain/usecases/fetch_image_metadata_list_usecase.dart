import '../repositories/image_repository.dart';
import '../models/generated_image.dart';

class FetchImageMetadataListUseCase {
  final ImageRepository repository;

  FetchImageMetadataListUseCase({required this.repository});

  Future<List<GeneratedImage>> call({int limit = 10}) async {
    return await repository.fetchGeneratedImageList(limit: limit);
  } // call
} // FetchImageMetadataListUseCase
