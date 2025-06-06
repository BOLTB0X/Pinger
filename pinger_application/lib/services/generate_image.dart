import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final token = dotenv.env['HUGGINGFACE_TOKEN']!;

Future<Uint8List?> generateImage(String base64Sketch) async {
  String apiToken = dotenv.env['HUGGINGFACE_TOKEN']!;
  String apiUrl = dotenv.env['HUGGINGFACE_URL']!;

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Authorization': 'Bearer $apiToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'inputs': base64Sketch,
      'parameters': {'prompt': 'A fantasy castle with colorful sunset'},
    }),
  );

  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    print('실패: ${response.statusCode}, ${response.body}');
    return null;
  }
}
