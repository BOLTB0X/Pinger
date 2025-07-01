import '../../data/models/generated_image_dto.dart';

class GeneratedImage {
  final String id;
  final String prompt;
  final String filename;
  final String imageUrl;
  final DateTime timestamp;

  GeneratedImage({
    required this.id,
    required this.prompt,
    required this.filename,
    required this.imageUrl,
    required this.timestamp,
  }); // init

  factory GeneratedImage.fromJson(Map<String, dynamic> json) {
    return GeneratedImage(
      id: json['id'],
      prompt: json['prompt'],
      filename: json['filename'],
      imageUrl: json['image_url'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  } // fromJson

  GeneratedImageDTO toDTO() {
    return GeneratedImageDTO(
      id: id,
      prompt: prompt,
      filename: filename,
      imageUrl: imageUrl,
      timestamp: timestamp,
    );
  } // toDTO
} // GeneratedImage
