import '../../domain/models/generated_image.dart';

class GeneratedImageDTO {
  final String id;
  final String prompt;
  final String filename;
  final String imageUrl;
  final DateTime timestamp;

  GeneratedImageDTO({
    required this.id,
    required this.prompt,
    required this.filename,
    required this.imageUrl,
    required this.timestamp,
  }); // init

  factory GeneratedImageDTO.fromJson(Map<String, dynamic> json) {
    return GeneratedImageDTO(
      id: json['id'],
      prompt: json['prompt'],
      filename: json['filename'],
      imageUrl: json['image_url'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  } // fromJson

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prompt': prompt,
      'filename': filename,
      'image_url': imageUrl,
      'timestamp': timestamp.toIso8601String(),
    };
  } // toJson

  GeneratedImage toDomain() {
    return GeneratedImage(
      id: id,
      prompt: prompt,
      filename: filename,
      imageUrl: imageUrl,
      timestamp: timestamp,
    );
  } // toDomain
} // GeneratedImageDTO
