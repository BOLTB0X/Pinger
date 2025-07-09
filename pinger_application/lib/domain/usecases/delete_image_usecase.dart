// domain/usecases/delete_image_usecase.dart
import '../repositories/image_repository.dart';

class DeleteImageUseCase {
  final ImageRepository repository;

  DeleteImageUseCase({required this.repository});

  Future<bool> call(String filename) async {
    return await repository.deleteImage(filename);
  } // call
} // DeleteImageUseCase
