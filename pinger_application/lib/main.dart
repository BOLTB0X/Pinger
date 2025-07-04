import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'core/network/httpoverrides_service.dart';
import 'data/repositories/image_repository_impl.dart';
import 'data/datasources/remote_api_service.dart';

import 'domain/usecases/generate_image_usecase.dart';
import 'domain/usecases/save_image_usecase.dart';
import 'domain/usecases/fetch_image_metadata_list_usecase.dart';
import 'domain/entities/drawing_manager.dart';

import 'presentation/view/canvas_view.dart';
import 'presentation/viewmodel/canvas_viewmodel.dart';
import 'presentation/viewmodel/result_viewmodel.dart';
import 'presentation/viewmodel/image_list_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  HttpOverrides.global = HttpOverridesService();

  final colabURL = dotenv.env['COLAB_URL'];
  final flaskURL = dotenv.env['FLASK_URL'];

  final remoteApiService = RemoteApiService(
    colabURL: colabURL ?? 'http://localhost:5000',
    flaskURL: flaskURL ?? 'http://localhost:5000',
  );
  final imageRepository = ImageRepositoryImpl(remoteApiService);
  final generateImageUseCase = GenerateImageUseCase(
    repository: imageRepository,
  );
  final saveImageUseCase = SaveImageUseCase(repository: imageRepository);
  final fetchImageMetadataListUseCase = FetchImageMetadataListUseCase(
    repository: imageRepository,
  );

  runApp(
    MultiProvider(
      providers: [
        // DrawingManager
        ChangeNotifierProvider(create: (_) => DrawingManager()),
        // CanvasViewModel
        ChangeNotifierProvider(
          create: (context) => CanvasViewModel(
            context.read<DrawingManager>(),
            generateImageUseCase,
          ),
        ),
        // ResultViewModel
        ChangeNotifierProvider(
          create: (context) =>
              ResultViewModel(saveImageUseCase: saveImageUseCase),
        ),
        ChangeNotifierProvider(
          create: (context) => ImageListViewModel(
            fetchImageListUseCase: fetchImageMetadataListUseCase,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
} // main

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pinger',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CanvasView(),
    );
  } // build
} // MyApp
