import 'package:flutter/material.dart';
import 'screens/drawing_screen.dart';

void main() {
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
