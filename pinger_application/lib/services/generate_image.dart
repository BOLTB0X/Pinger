import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<Uint8List?> generateImage(String base64Sketch) async {
  String apiUrl = dotenv.env['HUGGINGFACE_URL']!;

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'image': base64Sketch}),
  );

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);
    final base64Result = decoded['result'];
    return base64Decode(base64Result);
  } else {
    print('실패: ${response.statusCode}, ${response.body}');
    return null;
  }
}
