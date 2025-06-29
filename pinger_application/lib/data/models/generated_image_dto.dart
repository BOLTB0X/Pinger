import '../../domain/models/generated_image.dart';
import '../../domain/models/generated_image_metadata.dart';

class GeneratedImageDTO {
  final String id;
  final String prompt;
  final String filename;
  final String timestamp;

  GeneratedImageDTO({
    required this.id,
    required this.prompt,
    required this.filename,
    required this.timestamp,
  }); // init

  factory GeneratedImageDTO.fromJson(Map<String, dynamic> json) {
    return GeneratedImageDTO(
      id: json['id'],
      prompt: json['prompt'],
      filename: json['filename'],
      timestamp: json['timestamp'],
    );
  } // fromJson

  GeneratedImage toEntity(String flaskUrl) {
    final metadata = GeneratedImageMetadata(
      id: id,
      prompt: prompt,
      filename: filename,
      timestamp: DateTime.parse(timestamp),
    );

    final imageUrl = "$flaskUrl/images/$filename";

    return GeneratedImage(metadata: metadata, imageUrl: imageUrl);
  } // toEntity
} // GeneratedImageDTO
