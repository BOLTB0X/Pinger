import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../domain/models/generated_image.dart';
import '../../domain/usecases/fetch_image_metadata_list_usecase.dart';

class ImageListViewModel extends ChangeNotifier {
  final FetchImageMetadataListUseCase fetchImageListUseCase;

  List<GeneratedImage> _images = [];
  List<GeneratedImage> get images => _images;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Timer? _timer;

  String _url = "";
  String get url => _url;

  ImageListViewModel({required this.fetchImageListUseCase}) {
    loadImages();
    startAutoRefresh();
    _url = dotenv.env['FLASK_URL'] ?? 'http://localhost:50';
  } // init

  Future<void> loadImages({int limit = 10}) async {
    _isLoading = true;
    notifyListeners();

    _images = await fetchImageListUseCase(limit: limit);

    _isLoading = false;
    notifyListeners();
  } // loadImages

  void startAutoRefresh({Duration interval = const Duration(seconds: 30)}) {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) async {
      await loadImages();
    });
  } // startAutoRefresh

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  } // dispose
} // ImageListViewModel
