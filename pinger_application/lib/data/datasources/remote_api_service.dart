import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:core';
import '../../domain/models/generated_image_metadata.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RemoteApiService {
  Future<Uint8List?> postImage(String base64Sketch, String prompt) async {
    try {
      final apiUrl = Uri.parse("${dotenv.env['FLASK_URL']}/generate");

      final response = await http.post(
        apiUrl,
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
      } // if - else
    } catch (e) {
      print("예외 발생: $e");
      return null;
    } // try - catch
  } // postImage

  Future<bool> postSaveImage({
    required Uint8List imageBytes,
    required String prompt,
    required String filename,
  }) async {
    try {
      final url = Uri.parse("${dotenv.env['FLASK_URL']}/create");

      final request = http.MultipartRequest('POST', url)
        ..fields['prompt'] = prompt
        ..fields['filename'] = filename
        ..files.add(
          http.MultipartFile.fromBytes(
            'image',
            imageBytes,
            filename: '$filename.png',
            contentType: MediaType('image', 'png'),
          ),
        ); // request

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return true;
      } else {
        print('저장 실패: ${response.statusCode} / ${response.body}');
        return false;
      } // if - else
    } catch (e) {
      print("예외 발생: $e");
      return false;
    } // try - catch
  } // postSaveImage

  Future<List<GeneratedImageMetadata>> getImageMetadataList({
    int limit = 10,
  }) async {
    try {
      final url = Uri.parse("${dotenv.env['FLASK_URL']}/read?limit=$limit");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> decoded = jsonDecode(response.body);
        return decoded.map((e) => GeneratedImageMetadata.fromJson(e)).toList();
      } else {
        print("불러오기 실패: ${response.statusCode}, ${response.body}");
        return [];
      } // if - else
    } catch (e) {
      print("예외 발생: $e");
      return [];
    } // try - catch
  }
} // RemoteApiService
