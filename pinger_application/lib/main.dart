import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'core/network/httpoverrides_service.dart';
import 'data/repositories/image_repository_impl.dart';
import 'data/datasources/remote_api_service.dart';
import 'domain/usecases/generate_image_usecase.dart';
import 'presentation/view/drawing_view.dart';
import 'presentation/viewmodel/drawing_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  HttpOverrides.global = HttpOverridesService();

  final remoteApiService = RemoteApiService();
  final imageRepository = ImageRepositoryImpl(remoteApiService);
  final generateImageUseCase = GenerateImageUseCase(
    repository: imageRepository,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => DrawingViewModel(generateImageUseCase),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pinger Sketch',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DrawingView(),
    );
  }
}
