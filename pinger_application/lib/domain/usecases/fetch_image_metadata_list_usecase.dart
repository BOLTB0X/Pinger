import '../repositories/image_repository.dart';
import '../models/generated_image_metadata.dart';

class FetchImageMetadataListUseCase {
  final ImageRepository repository;

  FetchImageMetadataListUseCase({required this.repository});

  Future<List<GeneratedImageMetadata>> call({int limit = 10}) async {
    return await repository.fetchImageMetadataList(limit: limit);
  } // call
} // FetchImageMetadataListUseCase
