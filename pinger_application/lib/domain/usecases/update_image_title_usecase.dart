import '../repositories/image_repository.dart';

class UpdateImageTitleUseCase {
  final ImageRepository repository;

  UpdateImageTitleUseCase({required this.repository});

  Future<bool> call({
    required String docId,
    required String newFileName,
  }) async {
    return await repository.updateImageTitle(docId, newFileName);
  }
}
