import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../domain/models/generated_image.dart';
import '../../domain/usecases/fetch_image_metadata_list_usecase.dart';
import '../../domain/usecases/delete_image_usecase.dart';
import '../../domain/usecases/update_image_title_usecase.dart';

class ImageListViewModel extends ChangeNotifier {
  final FetchImageMetadataListUseCase fetchImageListUseCase;
  final UpdateImageTitleUseCase updateImageTitleUseCase;
  final DeleteImageUseCase deleteImageUseCase;

  List<GeneratedImage> _images = [];
  List<GeneratedImage> get images => _images;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _url = "";
  String get url => _url;

  String? _editingDocId;
  String? get editingDocId => _editingDocId;

  final TextEditingController editingController = TextEditingController();

  ImageListViewModel({
    required this.fetchImageListUseCase,
    required this.updateImageTitleUseCase,
    required this.deleteImageUseCase,
  }) {
    _url = dotenv.env['FLASK_URL'] ?? 'http://localhost:50';
    loadImages();
  }

  Future<void> loadImages({int limit = 10}) async {
    _isLoading = true;
    notifyListeners();
    _images = await fetchImageListUseCase(limit: limit);
    _isLoading = false;
    notifyListeners();
  }

  void startEditing(GeneratedImage image) {
    _editingDocId = image.docId;
    editingController.text = _extractFileNameWithoutExtension(image.filename);
    notifyListeners();
  }

  void stopEditing() {
    _editingDocId = null;
    editingController.clear();
    notifyListeners();
  }

  Future<void> saveFileName(GeneratedImage image) async {
    final newFileName = editingController.text.trim();
    if (newFileName.isEmpty) return;
    final success = await updateImageTitleUseCase(
      docId: image.docId,
      newFileName: newFileName,
    );
    if (success) {
      await loadImages();
      stopEditing();
    }
  }

  Future<bool> deleteImage(String docId) async {
    final success = await deleteImageUseCase(docId);
    if (success) {
      _images.removeWhere((e) => e.docId == docId);
      notifyListeners();
    }
    return success;
  }

  String _extractFileNameWithoutExtension(String filename) {
    return filename.split('.').first;
  }
}
