import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RemoteApiService {
  Future<Uint8List?> postImage(
    String base64Sketch,
    String prompt,
    String apiPath,
  ) async {
    final apiUrl = dotenv.env['HUGGINGFACE_URL']! + apiPath;

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'image': base64Sketch, 'prompt': prompt}),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final base64Result = decoded['image'];
      if (base64Result == null) throw Exception("Response 'image' is null");
      return base64Decode(base64Result);
    } else {
      print('요청 실패: ${response.statusCode}, ${response.body}');
      return null;
    }
  }
}
