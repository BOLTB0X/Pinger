import 'package:flutter/material.dart';
import 'screens/drawing_screen.dart';
import 'services/my_http.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pinger Sketch',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DrawingScreen(),
    );
  }
}
